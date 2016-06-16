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
    var discipline = Discipline()
    var disciplines = Array<Discipline>()
    
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
                
                var disciplineJSONData = NSDictionary()
                
                do {
                    disciplineJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                } catch is NSCocoaError {
                    if   error!._domain == NSCocoaErrorDomain
                        && error!._code   == 3840 {
                        print("Invalid format")
                    }
                }
                if (disciplineJSONData.valueForKey(StringUtil.error) != nil) {
                    return
                } else {
                    
                    let disciplines : NSArray =  disciplineJSONData.valueForKey(StringUtil.lectures) as! NSArray
                    let events: NSArray = disciplines.valueForKey(StringUtil.event) as! NSArray
                    
                    self.disciplines = Discipline.iterateJSONArray(disciplines, events: events)
                    
                }
                print(disciplineJSONData)
            }
        })
        
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disciplines.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DisciplineTableViewCell
        let disc = disciplines[ indexPath.row ]
        
        cell.nameLabel.text = disc.name
        cell.startDateLabel.text = StringUtil.start + DateUtil.date(disc.startDate)
        cell.classeLabel.text = StringUtil.turma + (String(disc.classe))
        
        let imageBook = ImageUtil.imageDiscipline
        cell.bookImageView.image = imageBook
        cell.bookImageView.tintColor = UIColor.grayColor()

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        discipline = disciplines[ indexPath.row ]
        
        let presentationTabBar = PresentationsTabBarController()
        
        presentationTabBar.discipline = discipline
    
        self.navigationController?.pushViewController(presentationTabBar, animated: true)
    }
}
