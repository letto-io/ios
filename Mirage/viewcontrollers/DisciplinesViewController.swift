//
//  DisciplinesViewController.swift
//  Mirage
//
//  Created by Siena Idea on 18/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DisciplinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var discipline = Array<Discipline>()
    
    var id: Int = Discipline().id
    var profile: Int = Discipline().profile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(OpenPresentationsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
            tableView.addSubview(refreshControl) // not required when using UITableViewController
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            refreshTableView()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            refreshTableView()
        }
    }
    
    func refreshTableView() {
        
        if tableView == nil {
            return
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "DisciplineCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        getInstruction()
        tableView.reloadData()
    }
    
    // pull to refresh
    func refresh() {
        getInstruction()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getInstruction() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.disciplineURL
        let url = NSURL(string: urlPath)!
        
        let cookieHeaderField = ["Set-Cookie": "key=value"]
        
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: url, mainDocumentURL: nil)
        
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        print(cookies)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print("Download Error: \(error!.localizedDescription)")
            } else {
                var studentJSONParseError: NSError?
                
                let disciplineJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if (studentJSONParseError != nil) {
                    
                    //print("JSON Parsing Error: \(studentJSONParseError!.localizedDescription)")
                    return
                    
                } else {
                    
                    if (disciplineJSONData.valueForKey("error") != nil) {
                        return
                    } else {
                        
                        let info : NSArray =  disciplineJSONData.valueForKey("lectures") as! NSArray
                        let event: NSArray = info.valueForKey("event") as! NSArray
                        
                        for i in 0 ..< info.count {
                            
                            let disciplines = Discipline()
                            let events = Event()
                            
                            for j in 0 ..< event.count {
                                events.name = event[j].valueForKey("name") as! String
                                events.code = event[j].valueForKey("code") as! String
                            }
                            
                            disciplines.id = info[i].valueForKey("id") as! Int
                            disciplines.event = events
                            disciplines.code = info[i].valueForKey("code") as! String
                            disciplines.startDate = info[i].valueForKey("startdate") as! String
                            disciplines.classe = info[i].valueForKey("class") as! Int
                            disciplines.endDate = info[i].valueForKey("enddate") as! String
                            disciplines.profile = info[i].valueForKey("profile") as! Int
                            disciplines.name = info[i].valueForKey("name") as! String
                            
                            if self.discipline.count == info.count {
                                return
                            } else {
                                self.discipline.insert(disciplines, atIndex: i)
                            }
                        }
                        
                    }
                    
                    print(disciplineJSONData)
                }
            }
        })
        
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discipline.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DisciplineTableViewCell
        let disc = discipline[ indexPath.row ]
        
        cell.nameLabel.text = disc.name
        cell.startDateLabel.text = disc.startDate
        cell.classeLabel.text = "Turma \(String(disc.classe))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        id = discipline[ indexPath.row ].id
        profile = discipline[ indexPath.row ].profile
        
        let presentation = PresentationsTabBarController()
        
        presentation.idDisc = id
        presentation.profileDisc = profile
        
        self.presentViewController(presentation, animated: true, completion: nil)
        
    }
    
    
    init() {
        super.init(nibName: "DisciplinesViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }


    @IBAction func menuAction(sender: AnyObject) {
    }
    

}
