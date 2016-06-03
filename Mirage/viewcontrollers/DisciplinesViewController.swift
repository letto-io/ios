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
            refreshTableView()
            
            refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
            refreshControl.tintColor = ColorUtil.orangeColor
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
        let nib = UINib(nibName: StringUtil.disciplineCell , bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: StringUtil.cellIdentifier)
        view.addSubview(tableView)
        
        self.navigationItem.title = StringUtil.titleDiscipline
        
        if self.revealViewController() != nil {
            
            let menuButton = UIBarButtonItem(image: ImageUtil.imageMenuButton, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.setLeftBarButtonItem(menuButton, animated: true)
        }
        
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
                
                do {
                    let disciplineJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if (disciplineJSONData.valueForKey(StringUtil.error) != nil) {
                        return
                    } else {
                        
                        let info : NSArray =  disciplineJSONData.valueForKey(StringUtil.lectures) as! NSArray
                        let event: NSArray = info.valueForKey(StringUtil.event) as! NSArray
                        
                        for i in 0 ..< info.count {
                            
                            let disciplines = Discipline()
                            let events = Event()
                            
                            for j in 0 ..< event.count {
                                events.name = event[j].valueForKey(StringUtil.name) as! String
                                events.code = event[j].valueForKey(StringUtil.code) as! String
                            }
                            
                            disciplines.id = info[i].valueForKey(StringUtil.id) as! Int
                            disciplines.event = events
                            disciplines.code = info[i].valueForKey(StringUtil.code) as! String
                            disciplines.startDate = info[i].valueForKey(StringUtil.startdate) as! String
                            disciplines.classe = info[i].valueForKey(StringUtil.classe) as! Int
                            disciplines.endDate = info[i].valueForKey(StringUtil.enddate) as! String
                            disciplines.profile = info[i].valueForKey(StringUtil.profile) as! Int
                            disciplines.name = info[i].valueForKey(StringUtil.name) as! String
                            
                            if self.discipline.count == info.count {
                                return
                            } else {
                                self.discipline.insert(disciplines, atIndex: i)
                            }
                        }
                        
                    }
                    print(disciplineJSONData)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    return
                }
            }
        })
        
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discipline.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DisciplineTableViewCell
        let disc = discipline[ indexPath.row ]
        
        cell.nameLabel.text = disc.name
        cell.startDateLabel.text = StringUtil.start + DateUtil.date(disc.startDate)
        cell.classeLabel.text = StringUtil.turma + (String(disc.classe))
        
        let imageBook = ImageUtil.imageDiscipline
        cell.bookImageView.image = imageBook
        cell.bookImageView.tintColor = UIColor.grayColor()

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
}
