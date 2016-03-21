    //
//  LoggedViewController.swift
//  Mirage
//
//  Created by Siena Idea on 02/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!  
    
    var discipline = Array<Discipline>()
    
    var disciplines = [Discipline()]
    
    func refleshTableView() {
        
        if tableView == nil {
            return
        }
        
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view?.addSubview(self.tableView)
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
            
        } else {
            
            addLDisciplines()
            refleshTableView()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
            
        } else {
            addLDisciplines()
            refleshTableView()
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
            
        } else {
            addLDisciplines()
            refleshTableView()
        }
    }
    
    func addLDisciplines() {
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
                
                let lectureJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if (studentJSONParseError != nil) {
                    
                    print("JSON Parsing Error: \(studentJSONParseError!.localizedDescription)")
                    
                } else {
                    
                    let info : NSArray =  lectureJSONData.valueForKey("lectures") as! NSArray
                    let event: NSArray = info.valueForKey("event") as! NSArray
                    
                    
                    for var i = 0; i < info.count; i++ {
                        
                        let disciplines = Discipline()
                        let events = Event()
                        
                        for var j = 0; j < event.count; j++ {
                            events.name = event[i].valueForKey("name") as! String
                            events.code = event[i].valueForKey("code") as! String
                        }
                        
                        
                        disciplines.id = info[i].valueForKey("id") as! Int
                        disciplines.event = events
                        disciplines.code = info[i].valueForKey("code") as! String
                        disciplines.startDate = info[i].valueForKey("startdate") as! String
                        disciplines.classe = info[i].valueForKey("class") as! Int
                        disciplines.endDate = info[i].valueForKey("enddate") as! String
                        disciplines.profile = info[i].valueForKey("profile") as! Int
                        disciplines.name = info[i].valueForKey("name") as! String
                        
                        self.discipline.insert(disciplines, atIndex: i)
                        
                    }
                    
                    print(lectureJSONData)
                }
            }
        })
        
        task.resume()
        
        self.disciplines = discipline

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discipline.count;
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let discipline = disciplines[ row ]
        let cellIdentifier = "cell"
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "StarJediOutline", size:15)
        cell.textLabel?.text = discipline.name
        
        let startDate = UILabel(frame: CGRectMake(150.0, 20.0, 100.0, 30.0))
        startDate.text = discipline.startDate
        startDate.tag = indexPath.row
        startDate.font = UIFont(name: "Avenir", size: 10)
        cell.contentView.addSubview(startDate)
        
        let classe = UILabel(frame: CGRectMake(15.0, 20.0, 100.0, 30.0))
        classe.text = "Turma \(String(discipline.classe))"
        classe.tag = indexPath.row
        classe.font = UIFont(name: "Avenir", size: 10)
        cell.contentView.addSubview(classe)
        
        return cell
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
}
