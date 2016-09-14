//
//  AttachmentDoubtResponseViewController.swift
//  Mirage
//
//  Created by Oddin on 10/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class AttachmentAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    var attachmentAnswers = Array<Answer>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getAnswers()
        tableView.reloadData()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.AnswerCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(AttachmentAnswerViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAnswers()
    }
    
    // pull to refresh
    func refresh() {
        getAnswers()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getAnswers() {
        let request = Server.getRequestNew(url: Server.url + Server.questions + "\(question.id)" + Server.answers)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                print(response)
                let material = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                
                print(material)
                
            }
        }) 
        task.resume()
        
//        attachmentAnswers.removeAll()
//        
//        var auxContributions = Array<Contributions>()
//        
//        for i in 0 ..< .count {
//            var j = 0
//            
//            if contributions[i].mcmaterial.mime.containsString(StringUtil.image) ||
//                contributions[i].mcmaterial.mime.containsString(StringUtil.applicationPdf) {
//                auxContributions.insert(contributions[i], atIndex: j)
//                j += 1
//            }
//        }
//        attachmentAnswers = auxContributions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachmentAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! AnswerTableViewCell
        
        
        
        return cell
    }
    
    init() {
        super.init(nibName: StringUtil.AttachmentAnswerViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
