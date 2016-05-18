//
//  DisciplinesViewController.swift
//  Mirage
//
//  Created by Siena Idea on 18/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DisciplinesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var discipline = Array<Discipline>()
    
    var id = Discipline().id
    var profile: Int = Discipline().profile
    var name: String = Discipline().name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            
            self.navigationItem.title = "Disciplinas"
            
            refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(OpenPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
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
            self.navigationItem.title = "Disciplinas"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            refreshTableView()
            self.navigationItem.title = "Disciplinas"
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
                var disciplineJSONParseError: NSError?
                
                let disciplineJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if (disciplineJSONParseError != nil) {
                    
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
        
        cell.nameLabel.textColor = ColorUtil.colorPrimaryText
        cell.startDateLabel.textColor = ColorUtil.colorSecondaryText
        cell.classeLabel.textColor = ColorUtil.colorSecondaryText
        
        cell.nameLabel.text = disc.name
        cell.startDateLabel.text = disc.startDate
        cell.classeLabel.text = "Turma \(String(disc.classe))"
        
        let imageBook = UIImage(named: "book-multiple-black.png")
        cell.bookImageView.image = imageBook
        
        cell.bookImageView.image = imageBook!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.bookImageView.tintColor = UIColor.darkGrayColor()
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        id = discipline[ indexPath.row ].id
        profile = discipline[ indexPath.row ].profile
        name = discipline[ indexPath.row ].name
        
        let presentationTabBar = PresentationsTabBarController()
        
        presentationTabBar.idDisc = id
        presentationTabBar.profileDisc = profile
        presentationTabBar.nameDisc = name
        
        self.navigationController?.pushViewController(presentationTabBar, animated: true)
    }
    
    init() {
        super.init(nibName: "DisciplinesViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
