    //
//  LoggedViewController.swift
//  Mirage
//
//  Created by Siena Idea on 02/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    
    override func viewDidAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
            
        }
    }
    
    
    
    func getData(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        
        let url = NSURL(string: Server.lectureURL)
        
        // First
        let cookie = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookieHeaderField = ["Set-Cookie": "key=value"] // Or ["Set-Cookie": "key=value, key2=value2"] for multiple cookies
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url!)
        cookie.setCookies(cookies, forURL: url, mainDocumentURL: url)
        
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        
        
        request.HTTPMethod = "GET"
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            
            
            var error: NSError?
            //let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                //return completionHandler(json["results"] as [NSDictionary], nil)
            }
        })
        task.resume()
    }



    var tableView: UITableView!
    var items: NSMutableArray = []
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        
        if cookies.isEmpty {
            self.performSegueWithIdentifier("loginView", sender: self)
            
        } else {
            self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
            self.tableView = UITableView(frame:self.view!.frame)
            self.tableView!.delegate = self
            self.tableView!.dataSource = self
            self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.view?.addSubview(self.tableView)
            
                    getData({data, error -> Void in
                        if (data != nil) {
                            self.items = NSMutableArray(array: data)
                            self.tableView!.reloadData()
            
                        } else {
                            print("api.getData failed")
                            print(error)
                        }
                    })
        }
        
        
        
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        if let navn = self.items[indexPath.row]["trackName"] as? NSString {
            //cell.textLabel.text = navn
        } else {
            //cell.textLabel.text = "No Name"
        }
        
        if let desc = self.items[indexPath.row]["description"] as? NSString {
            //cell.detailTextLabel.text = desc
        }
        
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
        
        self.performSegueWithIdentifier("loginView", sender: self)
        
    }
}
