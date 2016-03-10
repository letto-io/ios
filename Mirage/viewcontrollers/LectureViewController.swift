    //
//  LoggedViewController.swift
//  Mirage
//
//  Created by Siena Idea on 02/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    
//    override func viewDidAppear(animated: Bool) {
//        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
//        
//        if cookies.isEmpty {
//            self.performSegueWithIdentifier("loginView", sender: self)
//            
//        }
//    }
    

    @IBOutlet weak var tableView: UITableView!
    
    var items: NSMutableArray = []
    
    override func viewWillAppear(animated: Bool) {
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
                    self.items = NSMutableArray(array: data)
                    self.tableView!.reloadData()
                
                if data == nil {
                    print("Data failed", error)
                } else {
                    print("Sucess", data)
                }
                
            })
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        if let navn = self.items[indexPath.row]["trackName"] as? NSString {
            cell.textLabel!.text = navn as String
        } else {
                cell.textLabel!.text = "No Name"
        }
        
        if let desc = self.items[indexPath.row]["description"] as? NSString {
            cell.detailTextLabel!.text = desc as String
        }
        
        return cell
    }
    
    func getData(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.lectureURL
        let url = NSURL(string: urlPath)!
        
        let cookieHeaderField = ["Set-Cookie": "key=value"]
        
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: url, mainDocumentURL: nil)
        
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        print(cookies)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            
            
            print(json)
        })
        task.resume()
        
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
