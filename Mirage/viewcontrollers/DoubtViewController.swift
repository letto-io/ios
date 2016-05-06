//
//  DoubtViewController.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DoubtViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var idDisc = Discipline().id
    var profileDisc = Discipline().profile
    var nameDisc = Discipline().name
    var idPresent = Presentation().id
    var subjectPresent = Presentation().subject
    
    var doubt  = Array<Doubt>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            let nib = UINib(nibName: "DoubtTableViewCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            view.addSubview(tableView)
            
            getDoubt()
            tableView.reloadData()
        }
    }
    
    func getDoubt() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + "/presentation/" + "\(idPresent)" + "/doubt"
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
                var doubtJSONParseError: NSError?
                
                let doubtJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if (doubtJSONParseError != nil) {
                    
                    //print("JSON Parsing Error: \(studentJSONParseError!.localizedDescription)")
                    return
                    
                } else {
                    
                    if (doubtJSONData.valueForKey("error") != nil) {
                        return
                    } else {
                        
                        if doubtJSONData.valueForKey("doubts")?.count == 0 {
                            return
                        } else {
                            
                            let info =  doubtJSONData.valueForKey("doubts") as! NSDictionary
                            
                            let keys = info.allKeys
                            
                            for i in 0 ..< keys.count {
                                
                                if self.doubt.count == info.count {
                                    return
                                } else {
                                    
                                    let doubts = Doubt()
                                    let person = Person()
                                    
                                    let key = keys[i] as! String
                                    let doubt = info.valueForKey(key)!
                                    
                                    for j in 0 ..< keys.count {
                                        let key = doubt.valueForKey("person")!
                                        person.id = key.valueForKey("id") as! Int
                                        person.name = key.valueForKey("name") as! String
                                    }
                                    
                                    doubts.id = doubt.valueForKey("id") as! Int
                                    doubts.contributions = doubt.valueForKey("contributions") as! Int
                                    doubts.likes = doubt.valueForKey("likes") as! Int
                                    doubts.status = doubt.valueForKey("status") as! Int
                                    doubts.presentationId = doubt.valueForKey("presentationid") as! Int
                                    doubts.text = doubt.valueForKey("text") as! String
                                    doubts.createdat = doubt.valueForKey("createdat") as! String
                                    doubts.anonymous = doubt.valueForKey("anonymous") as! Bool
                                    doubts.like = doubt.valueForKey("like") as! Bool
                                    doubts.person = person
                                    
                                    self.doubt.insert(doubts, atIndex: i)
                                }
                            }
                        }
                    }
                    
                    print(doubtJSONData)
                }
            }
        })
        
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return doubt.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DoubtTableViewCell
        
        let doubts = doubt[ indexPath.row ]
        
        cell.nameLabel.text = doubts.person.name
        cell.textDoubtLabel.text = doubts.text
        cell.hourLabel.text = doubts.createdat
        cell.likesLabel.text = String(doubts.likes)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    init() {
        super.init(nibName: "DoubtViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    
}
