//
//  LoggedViewController.swift
//  Mirage
//
//  Created by Siena Idea on 02/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    @IBOutlet weak var tableView: UITableView!
//    
//    var deleagte = AddALectureDelegate?.self
//    var selected = Array<Lecture>()
//    
//    var lectures = 	[Lecture(id: "1", startDate: "01/01/2016", endDate: "06/06/2016", classe: "sdsd", code: "01", name: "Teste", profile: "teste")]
//    
//    override func viewDidLoad() {
//        
//        tableView.reloadData()
//    }
//    	
//    override func viewDidAppear(animated: Bool) {
//        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
//                
//            if cookies.isEmpty {
//                self.performSegueWithIdentifier("loginView", sender: self)
//            
//        }
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return lectures.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let row = indexPath.row
//        let lecture = lectures[ row ]
//        var cell = UITableViewCell(style:
//            UITableViewCellStyle.Default, reuseIdentifier: nil)
//        cell.textLabel?.text = lecture.name
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        if cell == nil {
//            return
//        }
//        if cell!.accessoryType == UITableViewCellAccessoryType.None {
//            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
//            selected.append(lectures[indexPath.row])
//        } else {
//            cell!.accessoryType = UITableViewCellAccessoryType.None
//            
//            //                        if let positon = selected.indexOf(itens[indexPath.row]) {
//            //                            selected.removeAtIndex(positon)
//            //                        }
//        }
//        
//    }
    
    
    var tableView: UITableView!
    var items: NSMutableArray = []
    
    var api = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        self.tableView = UITableView(frame:self.view!.frame)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view?.addSubview(self.tableView)
        
        api.loginButtonTapped({data, error -> Void in
            if (data != nil) {
                self.items = NSMutableArray(array: data)
                self.tableView!.reloadData()
                self.view
            } else {
                println("api.getData failed")
                println(error)
            }
        })
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        if let navn = self.items[indexPath.row]["trackName"] as? NSString {
            cell.textLabel.text = navn
        } else {
            cell.textLabel.text = "No Name"
        }
        
        if let desc = self.items[indexPath.row]["description"] as? NSString {
            cell.detailTextLabel.text = desc
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
