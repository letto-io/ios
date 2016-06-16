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
    
    var discipline = Discipline()
    var presentation = Presentation()
    var doubt = Doubt()
    var doubts = Array<Doubt>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        refreshControl.addTarget(self, action: #selector(DoubtViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        refreshTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTableView()
        
        if doubts.isEmpty {
            displayMyAlertMessage(presentation.subject, userMessage: StringUtil.msgNoDoubt)
        }
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
        let urlPath = Server.presentationURL+"\(discipline.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt
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
                let doubtJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                    if (doubtJSONData.valueForKey(StringUtil.error) != nil) {
                        return
                    } else {
                        if doubtJSONData.valueForKey(StringUtil.doubts)?.count == 0 {
                            return
                        } else {
                            let doubts =  doubtJSONData.valueForKey(StringUtil.doubts) as! NSDictionary
                            let keys = doubts.allKeys
                            
                            self.doubts = Doubt.iterateJSONArray(doubts, keys: keys)
                        }
                    }
                print(doubtJSONData)
            }
        })
        
        task.resume()
        
        doubts.sortInPlace({ $0.createdat > $1.createdat })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return doubts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DoubtTableViewCell
        
        let doubt = doubts[ indexPath.row ]
        
        if doubt.anonymous == false {
            cell.nameLabel.text = doubt.person.name
        } else {
            cell.nameLabel.text = StringUtil.anonimo
        }
        cell.textDoubtLabel.text = doubt.text
        cell.hourLabel.text = DateUtil.hour(doubt.createdat)
        cell.countLikesLabel.text = String(doubt.likes)
        cell.likeButton.setImage(ImageUtil.imageLikeButton, forState: .Normal)
        cell.likeButton.tintColor = ColorUtil.orangeColor
        
        if discipline.profile == 0 {
            cell.understandLabel.text = StringUtil.entendi
            cell.understandButton.setImage(ImageUtil.imageCheckBoxButtonWhite, forState: .Normal)
            cell.understandButton.tintColor = UIColor.grayColor()
        } else if discipline.profile == 2 {
            cell.understandLabel.text = ""
        }
        
        //passagem de id para url de like na dúvida
        cell.likeButton.tag = doubts[ indexPath.row ].id
        
        if doubt.like == false {
            cell.likeButton.addTarget(self, action: #selector(DoubtViewController.likeButtonPressed), forControlEvents: .TouchUpInside)
            cell.likeButton.setImage(ImageUtil.imageLikeButton, forState: .Normal)
            cell.likeButton.tintColor = UIColor.grayColor()
        } else {
            cell.likeButton.addTarget(self, action: #selector(DoubtViewController.deleteLikeButtonPressed), forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        doubt = doubts[ indexPath.row ]
        
        let doubtsResponse = DoubtsResponseTabBarViewController()
        
        doubtsResponse.discipline.id = discipline.id
        doubtsResponse.presentation.id = presentation.id
        doubtsResponse.doubt.id = doubt.id
        doubtsResponse.doubt.text = doubt.text

        self.navigationController?.pushViewController(doubtsResponse, animated: true)
    }
    
    func likeButtonPressed(sender: UIButton) {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(discipline.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(sender.tag)" + Server.like
        
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
                        [self .viewDidLoad()]
                        [self .viewDidAppear(true)]
                        [self .viewWillAppear(true)]
                        
                    }
                }
                print(response)
            }
        }
        task.resume()
        
    }
    
    func deleteLikeButtonPressed(sender: UIButton) {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(discipline.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(sender.tag)" + Server.like
        
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
    
    //exibe mensagens de alerta
    func displayMyAlertMessage(namePresentation: String, userMessage: String) {
        
        let myAlert = UIAlertController(title: namePresentation, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let backAction = UIAlertAction(title: StringUtil.back, style: .Destructive) { action -> Void in
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.ok, style: .Default) { action -> Void in
            
            print(StringUtil.ok)
        }
        
        myAlert.addAction(backAction)
        myAlert.addAction(okAction)

        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: StringUtil.doubtViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
