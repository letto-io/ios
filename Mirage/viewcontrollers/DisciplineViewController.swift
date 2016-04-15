    //
//  LoggedViewController.swift
//  Mirage
//
//  Created by Siena Idea on 02/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DisciplineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    var discipline = Array<Discipline>()
    
    var id: Int = Discipline().id
    var profile: Int = Discipline().profile
    
    func refreshTableView() {
        
        if tableView == nil {
            return
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "DisciplineCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.view?.addSubview(self.tableView)
//        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: Selector(getInstruction()), forControlEvents: UIControlEvents.ValueChanged)
//        tableView.addSubview(refreshControl)
        
        getInstruction()
    
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
            
        } else {
            
            refreshTableView()
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
            
        } else {
            
            refreshTableView()
        }
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
                        
                        self.performSegueWithIdentifier("loginView", sender: self)
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
        
        performSegueWithIdentifier("presentationView", sender: self)
        
    }
    
    
    @IBAction func signoutButtonTapped(sender: AnyObject) {
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        print("Cookies.count: \(cookies.count)")
        for cookie in cookies {
            print("name: \(cookie.name) value: \(cookie.value)")
            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
        }
        
        
        discipline.removeAll()
        
        self.performSegueWithIdentifier("loginView", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "presentationView") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! PresentationViewController
            // your new view controller should have property that will store passed value
            viewController.idDisc = id
            viewController.profileDisc = profile
        }
        
    }
    
}
