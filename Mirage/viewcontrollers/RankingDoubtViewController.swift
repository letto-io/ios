//
//  RankingDoubtViewController.swift
//  Mirage
//
//  Created by Siena Idea on 11/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class RankingDoubtViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.addTarget(self, action: #selector(ClosedPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
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
            let nib = UINib(nibName: StringUtil.doubtCell, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: StringUtil.cellIdentifier)
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
        let urlPath = Server.presentationURL+"\(idDisc)" + Server.presentaion_bar + "\(idPresent)" + Server.doubt
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
                var doubtJSONParseError: NSError?
                
                let doubtJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if (doubtJSONParseError != nil) {
                    
                    //print("JSON Parsing Error: \(studentJSONParseError!.localizedDescription)")
                    return
                    
                } else {
                    
                    if (doubtJSONData.valueForKey(StringUtil.error) != nil) {
                        return
                    } else {
                        
                        if doubtJSONData.valueForKey(StringUtil.doubts)?.count == 0 {
                            return
                        } else {
                            
                            let info =  doubtJSONData.valueForKey(StringUtil.doubts) as! NSDictionary
                            
                            let keys = info.allKeys
                            
                            for i in 0 ..< keys.count {
                                
                                if self.doubt.count == info.count {
                                    return
                                } else {
                                    
                                    let doubts = Doubt()
                                    let person = Person()
                                    
                                    let key = keys[i] as! String
                                    let doubt = info.valueForKey(key)!
                                    
                                    for _ in 0 ..< keys.count {
                                        let key = doubt.valueForKey(StringUtil.person)!
                                        person.id = key.valueForKey(StringUtil.id) as! Int
                                        person.name = key.valueForKey(StringUtil.name) as! String
                                    }
                                    
                                    doubts.id = doubt.valueForKey(StringUtil.id) as! Int
                                    doubts.contributions = doubt.valueForKey(StringUtil.contributions) as! Int
                                    doubts.likes = doubt.valueForKey(StringUtil.likes) as! Int
                                    doubts.status = doubt.valueForKey(StringUtil.status) as! Int
                                    doubts.presentationId = doubt.valueForKey(StringUtil.presentationid) as! Int
                                    doubts.text = doubt.valueForKey(StringUtil.text) as! String
                                    doubts.createdat = doubt.valueForKey(StringUtil.createdat) as! String
                                    doubts.anonymous = doubt.valueForKey(StringUtil.anonymous) as! Bool
                                    doubts.like = doubt.valueForKey(StringUtil.like) as! Bool
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
        
        doubt.sortInPlace({ $0.likes > $1.likes })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return doubt.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DoubtTableViewCell
        
        let doubts = doubt[ indexPath.row ]
        
        if doubts.anonymous == false {
            cell.nameLabel.text = doubts.person.name
        } else {
            cell.nameLabel.text = StringUtil.anonimo
        }
        
        cell.textDoubtLabel.text = doubts.text
        cell.hourLabel.text = DateUtil.hour(doubts.createdat)
        cell.countLikesLabel.text = String(doubts.likes)
        cell.understandLabel.text = StringUtil.entendi
        
        
        
        cell.likeButton.setImage(ImageUtil.imageLikeButtonBlack, forState: .Normal)
        cell.understandButton.setImage(ImageUtil.imageUnderstandButtonBlack, forState: .Normal)
        cell.likeButton.tintColor = ColorUtil.colorSecondaryText
        cell.understandButton.tintColor = ColorUtil.colorSecondaryText
        
        //passagem de id para url de like na dúvida
        cell.likeButton.tag = doubt[ indexPath.row ].id
        
        if doubts.like == false {
            cell.likeButton.addTarget(self, action: #selector(DoubtViewController.likeButtonPressed), forControlEvents: .TouchUpInside)
            cell.likeButton.setImage(ImageUtil.imageLikeButton, forState: .Normal)
        } else {
            cell.likeButton.addTarget(self, action: #selector(DoubtViewController.deleteLikeButtonPressed), forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        id = doubt[ indexPath.row ].id
    }
    
    func likeButtonPressed(sender: UIButton) {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + Server.presentaion_bar + "\(idPresent)" + Server.doubt_bar + "\(sender.tag)" + Server.like
        
        request.URL = NSURL(string: urlPath)
        request.HTTPMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print(error)
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                    let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                    
                    if httpResponse.statusCode == 404 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage(StringUtil.msgErrorRequest)
                        })
                    }
                    
                    if httpResponse.statusCode == 401 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage(StringUtil.msgNotRankYourDoubt)
                        })
                    }
                    
                    if httpResponse.statusCode == 200 {
                        //self.doubt.removeAll()
                        
                    }
                }
                print(response)
            }
        }
        task.resume()
        
    }
    
    func deleteLikeButtonPressed(sender: UIButton) {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + Server.presentaion_bar + "\(idPresent)" + Server.doubt_bar + "\(sender.tag)" + Server.like
        
        request.URL = NSURL(string: urlPath)
        request.HTTPMethod = StringUtil.httpDELETE
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print(error)
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                    let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                    
                    if httpResponse.statusCode == 404 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage(StringUtil.msgErrorRequest)
                        })
                    }
                    
                    if httpResponse.statusCode == 401 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.displayMyAlertMessage(StringUtil.error401)
                        })
                    }
                    
                    
                    if httpResponse.statusCode == 200 {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            //self.doubt.removeAll()
                            
                        })
                    }
                }
                print(response)
            }
        }
        task.resume()
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: StringUtil.ok, style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    init() {
        super.init(nibName: StringUtil.rankingDoubtViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
