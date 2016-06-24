//
//  DisciplinesViewController.swift
//  Mirage
//
//  Created by Siena Idea on 18/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DisciplinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var discipline = Discipline()
    var disciplines = Array<Discipline>()

    func tableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        getInstruction()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = StringUtil.titleDiscipline
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        tableViews()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.disciplineCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(DisciplinesViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        if self.revealViewController() != nil {
            let menuButton = UIBarButtonItem(image: ImageUtil.imageMenuButton, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.setLeftBarButtonItem(menuButton, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableViews()
    }
    
    // pull to refresh
    func refresh() {
        getInstruction()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getInstruction() {
        let url = Server.getRequest(Server.disciplineURL)

        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                var disciplineJSONData = NSDictionary()
                
                do {
                    disciplineJSONData =  try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                } catch is NSCocoaError {
                    if error!._domain == NSCocoaErrorDomain
                        && error!._code  == 3840 {
                        print("Invalid format")
                    }
                }
                if (disciplineJSONData.valueForKey(StringUtil.error) != nil) {
                    return
                } else {
                    let disciplines : NSArray =  disciplineJSONData.valueForKey(StringUtil.lectures) as! NSArray
                    let events: NSArray = disciplines.valueForKey(StringUtil.event) as! NSArray
                    
                    self.disciplines = Discipline.iterateJSONArray(disciplines, events: events)
                }
                print(disciplineJSONData)
            }
        })
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disciplines.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DisciplineTableViewCell
        let disc = disciplines[ indexPath.row ]
        
        cell.nameLabel.text = disc.name
        cell.startDateLabel.text = StringUtil.start + DateUtil.date(disc.startDate)
        cell.classeLabel.text = StringUtil.turma + (String(disc.classe))
        
        let imageBook = ImageUtil.imageDiscipline
        cell.bookImageView.image = imageBook
        cell.bookImageView.tintColor = UIColor.grayColor()

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        discipline = disciplines[ indexPath.row ]
        
        let presentationTabBar = PresentationsTabBarController()
        presentationTabBar.discipline = discipline
    
        self.navigationController?.pushViewController(presentationTabBar, animated: true)
    }
}
