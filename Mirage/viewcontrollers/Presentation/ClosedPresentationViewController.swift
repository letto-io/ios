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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        refreshControl.addTarget(self, action: #selector(ClosedPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        refreshTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshTableView()
    }
    
    func refreshTableView() {
        
        if tableView == nil {
            return
        } else {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: StringUtil.presentationCell, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: StringUtil.cellIdentifier)
            view.addSubview(tableView)
            
            getPresentation()
            tableView.reloadData()
        }
    }
    
    // pull to refresh
    func refresh() {
        getPresentation()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getPresentation() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(discipline.id)" + Server.presentaion
        let url = NSURL(string: urlPath)!
        
        let cookieHeaderField = [StringUtil.set_Cookie : StringUtil.key_Value]
        
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: url, mainDocumentURL: nil)
        
        request.HTTPMethod = StringUtil.httpGET
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        print(cookies)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let presentationJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
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
        
        doubtTabBar.discipline.id = discipline.id
        doubtTabBar.discipline.profile = discipline.profile
        doubtTabBar.discipline.name = discipline.name
        
        doubtTabBar.presentation.id = presentation.id
        doubtTabBar.presentation.subject = presentation.subject
        
        self.navigationController?.pushViewController(doubtTabBar, animated: true)
    }
    
    init() {
        super.init(nibName: StringUtil.closedPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
