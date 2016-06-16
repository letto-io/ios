//
//  OpenPresentationViewController.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class OpenPresentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewPresentationDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var discipline = Discipline()
    var presentation = Presentation()
    var presentations = Array<Presentation>()
    var openPresentation = Array<Presentation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        refreshControl.addTarget(self, action: #selector(OpenPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        //verifica se é um perfil de professor para fechar apresentações
        if discipline.profile == 2 {
            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(OpenPresentationViewController.longPress(_:)))
            self.view.addGestureRecognizer(longPressRecognizer)
            
        }
        
        refreshTableView()
    }

    
    override func viewDidAppear(animated: Bool) {
        refreshTableView()
        
        if presentations.isEmpty {
            displayMyAlertMessage(StringUtil.msgNoPresentation)
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
            let nib = UINib(nibName: StringUtil.presentationCell, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: StringUtil.cellIdentifier)
            view.addSubview(tableView)
            
            getPresentation()
            tableView.reloadData()
        }
    }
    
    //chama displayAlert para fechar apresentação
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = longPressGestureRecognizer.locationInView(self.tableView)
            
            if let indexPah = tableView.indexPathForRowAtPoint(touchPoint) {
                
                let id  = openPresentation[ indexPah.row ].id
                let subject  = openPresentation[ indexPah.row ].subject
                
                displayMyAlertMessage(StringUtil.msgClosePresentation, subject: subject, id: id)
            }
        }
    }
    
    // pull to refresh
    func refresh() {
        getPresentation()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getPresentation() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(discipline.id)" + Server.presentaion
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
                
                let presentationJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let presentations : NSArray =  presentationJSONData.valueForKey(StringUtil.presentations) as! NSArray
                let persons : NSArray = presentations.valueForKey(StringUtil.person) as! NSArray
                
                self.presentations = Presentation.iterateJSONArray(presentations, persons: persons)
                    
                print(presentationJSONData)
            }
        })
        
        task.resume()
        
        openPresentation.removeAll()
        
        var auxPresent = Array<Presentation>()
        
        for i in 0 ..< presentations.count {
            var j = 0
            
            if presentations[i].status == 0 {
                auxPresent.insert(presentations[i], atIndex: j)
                j += 1
            }
        }
        
        openPresentation = auxPresent.reverse()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return openPresentation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! PresentationTableViewCell
        
        let present = openPresentation[ indexPath.row ]
        
        cell.subjectLabel.text = present.subject
        cell.dateLabel.text = DateUtil.date1(present.createdat)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        presentation = openPresentation[ indexPath.row ]
        
        let doubtTabBar  = DoubtTabBarViewController()
        
        doubtTabBar.discipline.id = discipline.id
        doubtTabBar.discipline.profile = discipline.profile
        doubtTabBar.discipline.name = discipline.name
        
        doubtTabBar.presentation.id = presentation.id
        doubtTabBar.presentation.subject = presentation.subject
        
        self.navigationController?.pushViewController(doubtTabBar, animated: true)
    }
    
    //exibe mensagens de alerta
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle:
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
    
    //exibe mensagens de alerta
    func displayMyAlertMessage(userMessage: String, subject: String, id: Int) {
        
        let myAlert = UIAlertController(title: subject, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .Destructive) { action -> Void in
            
            let request: NSMutableURLRequest = NSMutableURLRequest()
            let urlPath = Server.presentationURL+"\(self.discipline.id)" + Server.presentaion_bar + "\(self.presentation.id)" + Server.close
            
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
                                
                                
                            })
                        }
                        
                        if httpResponse.statusCode == 401 {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                
                            })
                        }
                        
                        
                        if httpResponse.statusCode == 200 {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.navigationController?.popViewControllerAnimated(true)
                                
                            })
                        }
                    }
                    print(response)
                }
            }
            task.resume()
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .Cancel) { action -> Void in
            
            print(StringUtil.cancel)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: StringUtil.openPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
