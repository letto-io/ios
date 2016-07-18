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
    
    func tableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        getPresentation()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViews()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.presentationCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(OpenPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        //verifica se é um perfil de professor para fechar apresentações
        if discipline.profile == 2 {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(OpenPresentationViewController.longPress(_:)))
            self.view.addGestureRecognizer(longPressRecognizer)
        }
    }

    override func viewDidAppear(animated: Bool) {
        tableViews()
    }
    
    //chama displayAlert para fechar apresentação
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = longPressGestureRecognizer.locationInView(self.tableView)
            
            if let indexPah = tableView.indexPathForRowAtPoint(touchPoint) {
                let id  = openPresentation[ indexPah.row ].id
                let subject  = openPresentation[ indexPah.row ].subject
                
                alertMessageClosedPresentation(StringUtil.msgClosePresentation, subject: subject, id: id)
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
        let url = Server.getRequest(Server.presentationURL+"\(discipline.id)" + Server.presentaion)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let presentationJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
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
        doubtTabBar.discipline = discipline
        doubtTabBar.presentation = presentation
        
        self.navigationController?.pushViewController(doubtTabBar, animated: true)
    }
    
    //exibe mensagens de alerta
    func alertMessageClosedPresentation(userMessage: String, subject: String, id: Int) {
        let myAlert = UIAlertController(title: subject, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .Destructive) { action -> Void in
            let request = Server.postResquestNotSendCookie(Server.presentationURL+"\(self.discipline.id)" + Server.presentaion_bar + "\(id)" + Server.close)
            
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
                        } else if httpResponse.statusCode == 401 {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                
                            })
                        } else if httpResponse.statusCode == 200 {
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
