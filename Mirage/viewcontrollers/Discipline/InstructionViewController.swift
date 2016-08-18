//
//  DisciplinesViewController.swift
//  Mirage
//
//  Created by Siena Idea on 18/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var instructions = Array<Instruction>()

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
        refreshControl.addTarget(self, action: #selector(InstructionViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
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
        let request = Server.getRequestNew(Server.url + Server.instructions)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let instruction = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                let lecture: NSArray =  instruction.valueForKey(StringUtil.lecture) as! NSArray
                let event: NSArray = instruction.valueForKey(StringUtil.event) as! NSArray
                    
                self.instructions = Instruction.iterateJSONArray(instruction, lecture: lecture, event: event)
            }
        }
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DisciplineTableViewCell
        let disc = instructions[ indexPath.row ]
        
        cell.nameLabel.text = disc.lecture.name
        cell.startDateLabel.text = StringUtil.start + DateUtil.date(disc.start_date)
        cell.classeLabel.text = StringUtil.turma + (String(disc.class_number))
        
        let imageBook = ImageUtil.imageDiscipline
        cell.bookImageView.image = imageBook
        cell.bookImageView.tintColor = UIColor.grayColor()

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        instruction = instructions[ indexPath.row ]
        
        let presentationTabBar = PresentationsTabBarController()
        presentationTabBar.instruction = instruction
    
        self.navigationController?.pushViewController(presentationTabBar, animated: true)
    }
    
    init() {
        super.init(nibName: StringUtil.InstructionViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
