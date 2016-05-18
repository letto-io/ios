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
    var refreshControl: UIRefreshControl!
    
    var id  = Doubt().id
    var idDisc = Discipline().id
    var profileDisc = Discipline().profile
    var nameDisc = Discipline().name
    var idPresent = Presentation().id
    var subjectPresent = Presentation().subject
    
    var doubt  = Array<Doubt>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(DoubtViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
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
            let nib = UINib(nibName: "DoubtTableViewCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            view.addSubview(tableView)
            
            getDoubt()
            tableView.reloadData()
        }
    }
    
    // pull to refresh
    func refresh() {
        getDoubt()
        refreshControl.endRefreshing()
        tableView.reloadData()
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
        
        doubt.sortInPlace({ $0.createdat < $1.createdat })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return doubt.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DoubtTableViewCell
        
        let doubts = doubt[ indexPath.row ]
        
        cell.nameLabel.textColor = ColorUtil.colorPrimaryText
        cell.textDoubtLabel.textColor = ColorUtil.colorSecondaryText
        cell.hourLabel.textColor = ColorUtil.colorSecondaryText
        cell.countLikesLabel.textColor = ColorUtil.colorSecondaryText
        cell.understandLabel.textColor = ColorUtil.colorSecondaryText
        
        if doubts.anonymous == false {
            cell.nameLabel.text = doubts.person.name
        } else {
            cell.nameLabel.text = "Anônimo"
        }
        
        cell.textDoubtLabel.text = doubts.text
        cell.hourLabel.text = doubts.createdat
        cell.countLikesLabel.text = String(doubts.likes)
        cell.understandLabel.text = "ENTENDI"
        
        let imageLikeButton = UIImage(named: "arrow-up-bold-circle-outline.png")
        let imageUnderstandButton = UIImage(named: "checkbox-blank-outline-48.png")
        
        cell.likeButton.setImage(imageLikeButton, forState: .Normal)
        cell.understandButton.setImage(imageUnderstandButton, forState: .Normal)
        cell.likeButton.tintColor = ColorUtil.colorSecondaryText
        cell.understandButton.tintColor = ColorUtil.colorSecondaryText
        
        //passagem de id para url de like na dúvida
        
        id = doubts.id
        
        if doubts.like == false {
            cell.likeButton.addTarget(self, action: #selector(DoubtViewController.likeButtonPressed), forControlEvents: .TouchUpInside)
        } else {
            cell.likeButton.addTarget(self, action: #selector(DoubtViewController.deleteLikeButtonPressed), forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        id = doubt[ indexPath.row ].id
    }
    
    func likeButtonPressed() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + "/presentation/" + "\(idPresent)" + "/doubt/" + "\(id)" + "/like"
        
        request.URL = NSURL(string: urlPath)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                    let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                    
                    if httpResponse.statusCode == 404 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage("Não foi possível completar sua requisição")
                        })
                    }
                    
                    if httpResponse.statusCode == 401 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage("Você não pode ranquear sua propria dúvida!")
                        })
                    }
                    
                    
                    if httpResponse.statusCode == 200 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.tableView.reloadData()
                        })
                    }
                }
                print(response)
            }
        }
        task.resume()
        
    }
    
    func deleteLikeButtonPressed() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + "/presentation/" + "\(idPresent)" + "/doubt/" + "\(id)" + "/like"
        
        request.URL = NSURL(string: urlPath)
        request.HTTPMethod = "delete"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                    let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                    
                    if httpResponse.statusCode == 404 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage("Não foi possível completar sua requisição")
                        })
                    }
                    
                    if httpResponse.statusCode == 401 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage("Delete like erro 401!")
                        })
                    }
                    
                    
                    if httpResponse.statusCode == 200 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.refreshTableView()
                        })
                    }
                }
                print(response)
            }
        }
        task.resume()
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: "Mensagem", message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: "DoubtViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
