//
//  ClosedPresentationViewController.swift
//  Mirage
//
//  Created by Siena Idea on 20/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ClosedPresentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewPresentationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var presentations = Array<Presentation>()
    var closedPresentations = Array<Presentation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getPresentation()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.PresentationCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(ClosedPresentationViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPresentation()
    }
    
    // pull to refresh
    func refresh() {
        getPresentation()
        refreshControl.endRefreshing()
    }
    
    func getPresentation() {
        let request = Server.getRequestNew(url: Server.url + Server.instructions + "\(instruction.id)" + Server.presentations)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let presentation = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                let instruction : NSArray =  presentation.value(forKey: StringUtil.instruction) as! NSArray
                let person : NSArray = presentation.value(forKey: StringUtil.person) as! NSArray
                
                self.presentations = Presentation.iterateJSONArray(presentation, instruction: instruction, person: person)
                
                self.closedPresentations.removeAll()
                
                var auxPresent = Array<Presentation>()
                
                for i in 0 ..< self.presentations.count {
                    var j = 0
                    
                    if self.presentations[i].status == 1 {
                        auxPresent.insert(self.presentations[i], at: j)
                        j += 1
                    }
                }
                self.closedPresentations = auxPresent.reversed()
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }) 
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closedPresentations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! PresentationCell
        let present = closedPresentations[ (indexPath as NSIndexPath).row ]
        
        cell.subjectLabel.text = present.subject
        cell.dateLabel.text = DateUtil.dateAndHour(present.created_at)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentation = closedPresentations[ (indexPath as NSIndexPath).row ]
        
        let questionTabBar = QuestionsTabBarViewController()
        questionTabBar.instruction = instruction
        questionTabBar.presentation = presentation
    
        self.navigationController?.pushViewController(questionTabBar, animated: true)
    }
    
    init() {
        super.init(nibName: StringUtil.closedPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
