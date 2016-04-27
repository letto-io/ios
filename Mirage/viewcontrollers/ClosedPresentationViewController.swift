//
//  ClosedPresentationViewController.swift
//  Mirage
//
//  Created by Siena Idea on 20/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ClosedPresentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewPresentationDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var idDisc: Int = Discipline().id
    var profileDisc: Int = Discipline().profile
    
    var presentation = Array<Presentation>()
    var closedPresentation = Array<Presentation>()
    var id = Presentation().id
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navItem = UINavigationItem(title: "Apresentações");
        
        let back = UIBarButtonItem(title: "Voltar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ClosedPresentationViewController.back))
        
        navItem.leftBarButtonItem = back;
        navigationBar.setItems([navItem], animated: false);
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ClosedPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        //verifica se é um perfil de professor para criação de apresentações
        if profileDisc == 2 {
            
            let newPresentationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(OpenPresentationsViewController.showNewPresentation))
            
            navItem.rightBarButtonItem = newPresentationButton;
            navigationBar.setItems([navItem], animated: false)
        }
        
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
            let nib = UINib(nibName: "PresentationCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            view.addSubview(tableView)
            
            getPresentation()
            tableView.reloadData()
        }
    }
    
    func showNewPresentation() {
        
        let newPresentation = CreateNewPresentationViewController(delegate: self)
        
        newPresentation.id = idDisc
        
        self.presentViewController(newPresentation, animated: true, completion: nil)
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // pull to refresh
    func refresh() {
        getPresentation()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getPresentation() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + Server.presentation
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
                
                let presentationJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if (studentJSONParseError != nil) {
                    
                    print("JSON Parsing Error: \(studentJSONParseError!.localizedDescription)")
                    
                } else {
                    
                    let info : NSArray =  presentationJSONData.valueForKey("presentations") as! NSArray
                    let person : NSArray = info.valueForKey("person") as! NSArray
                    
                    for i in 0 ..< info.count {
                        if self.presentation.count == info.count {
                            return
                        } else {
                            
                            let presentations = Presentation()
                            let persons = Person()
                            
                            for j in 0 ..< person.count {
                                persons.name = person[j].valueForKey("name") as! String
                            }
                            
                            presentations.id = info[i].valueForKey("id") as! Int
                            presentations.person = persons
                            presentations.date = info[i].valueForKey("date") as! String
                            presentations.time = info[i].valueForKey("time") as! String
                            presentations.status = info[i].valueForKey("status") as! Int
                            presentations.subject = info[i].valueForKey("subject") as! String
                            
                            self.presentation.insert(presentations, atIndex: i)
                            var c = 0
                            
                            //verifica apenas as apresentacoes que estão abertas e insere em outro Array
                            if presentations.status == 1 {
                                c += 1
                                for k in 0 ..< c{
                                    self.closedPresentation.insert(presentations, atIndex: k)
                                }
                            }
                        }
                    }
                    print(presentationJSONData)
                }
            }
        })
        
        task.resume()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return closedPresentation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PresentationTableViewCell
        
        let present = closedPresentation[ indexPath.row ]
        
        cell.subjectLabel.text = present.subject
        
        cell.dateLabel.text = present.date
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        id = presentation[ indexPath.row ].id
        
        
        performSegueWithIdentifier("", sender: self)
    }
    
    init() {
        super.init(nibName: "ClosedPresentationViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
