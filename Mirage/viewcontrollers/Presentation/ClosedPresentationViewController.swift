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
    var discipline = Discipline()
    var presentation = Presentation()
    var presentations = Array<Presentation>()
    var closedPresentations = Array<Presentation>()
    
    func tableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        getPresentation()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.presentationCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(ClosedPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableViews()
    }
    
    // pull to refresh
    func refresh() {
        getPresentation()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getPresentation() {
        let url = Server.getRequest(Server.presentationURL+"\(discipline.id)" + Server.presentaion)
    
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let presentationJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let presentations : NSArray =  presentationJSONData.valueForKey(StringUtil.presentations) as! NSArray
                let persons : NSArray = presentations.valueForKey(StringUtil.person) as! NSArray
                    
                self.presentations = Presentation.iterateJSONArray(presentations, persons: persons)
                print(presentationJSONData)
            }
        })
        task.resume()
        
        closedPresentations.removeAll()
        
        var auxPresent = Array<Presentation>()
        
        for i in 0 ..< presentations.count {
            var j = 0
            
            if presentations[i].status == 1 {
                auxPresent.insert(presentations[i], atIndex: j)
                j += 1
            }
        }
        closedPresentations = auxPresent.reverse()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closedPresentations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! PresentationTableViewCell
        let present = closedPresentations[ indexPath.row ]
        
        cell.subjectLabel.text = present.subject
        cell.dateLabel.text = DateUtil.date1(present.createdat)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        presentation = closedPresentations[ indexPath.row ]
        
        let doubtTabBar  = DoubtTabBarViewController()
        doubtTabBar.discipline = discipline
        doubtTabBar.presentation = presentation
    
        self.navigationController?.pushViewController(doubtTabBar, animated: true)
    }
    
    init() {
        super.init(nibName: StringUtil.closedPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
