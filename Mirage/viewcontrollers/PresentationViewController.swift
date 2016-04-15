//
//  PresentationViewController.swift
//  Mirage
//
//  Created by Siena Idea on 23/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

    
class PresentationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddNewPresentationDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var idDisc: Int = Discipline().id
    var profileDisc: Int = Discipline().profile
    
    var presentation = Array<Presentation>()
    var id = Presentation().id
    
    func refreshTableView() {
        
        if tableView == nil {
            return
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "PresentationCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.view?.addSubview(self.tableView)
        
        getPresentation()
        
        tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navItem = UINavigationItem(title: "Apresentações");
        
        let back = UIBarButtonItem(title: "Voltar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PresentationViewController.back))
        
        navItem.leftBarButtonItem = back;
        navigationBar.setItems([navItem], animated: false);
        
        //verifica se é um perfil de professor para criação de apresentações
        if profileDisc == 2 {
            
            let newPresentationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(PresentationViewController.showNewPresentation))
            
            navItem.rightBarButtonItem = newPresentationButton;
            navigationBar.setItems([navItem], animated: false)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshTableView()
    }
    
    func showNewPresentation() {
        
        let newPresentation = CreateNewPresentationViewController(delegate: self)
        
        newPresentation.id = idDisc
        
        self.presentViewController(newPresentation, animated: true, completion: nil)
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
                        
                        let presentations = Presentation()
                        let persons = Person()
                        
                        for j in 0 ..< person.count {
                            //persons.id = person[j].valueForKey("id") as! Int
                            persons.name = person[j].valueForKey("name") as! String
                        }
                        
                        
                        presentations.id = info[i].valueForKey("id") as! Int
                        presentations.person = persons
                        presentations.date = info[i].valueForKey("date") as! String
                        presentations.time = info[i].valueForKey("time") as! String
                        presentations.status = info[i].valueForKey("status") as! Int
                        presentations.subject = info[i].valueForKey("subject") as! String
                        
                        if self.presentation.count == info.count {
                            return
                        } else {
                            self.presentation.insert(presentations, atIndex: i)
                        }
                    }
 
                    print(presentationJSONData)
                        
                }
            }
        })
        
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PresentationTableViewCell
        
        let present = presentation[ indexPath.row ]
        
        cell.subjectLabel.text = present.subject
        
        cell.dateLabel.text = present.date
        
        cell.closePresentationButton.tag = indexPath.row
        id = present.id
        cell.closePresentationButton.addTarget(self, action: #selector(PresentationViewController.closePresentationButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        id = presentation[ indexPath.row ].id
        
        
        performSegueWithIdentifier("", sender: self)
    }
    
    
    func closePresentationButtonPressed(sender: UIButton) {
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + Server.presentation + "/" + "\(id)" + "/close"
        let url = NSURL(string: urlPath)!
        
        let cookieHeaderField = ["Set-Cookie": "key=value"]
        
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: url, mainDocumentURL: nil)
        
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        
        
        
        
    }
        
}

    

