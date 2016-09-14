//
//  DisciplinesViewController.swift
//  Mirage
//
//  Created by Siena Idea on 18/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class InstructionViewController: ChildViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var instructions = Array<Instruction>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = StringUtil.titleDiscipline
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        tableView.delegate = self
        tableView.dataSource = self
        getInstruction()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.InstructionCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(InstructionViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInstruction()
    }
    
    // pull to refresh
    func refresh() {
        getInstruction()
        refreshControl.endRefreshing()
    }
    
    func getInstruction() {
        let request = Server.getRequestNew(url: Server.url + Server.instructions)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let instruction = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                let lecture: NSArray =  instruction.value(forKey: StringUtil.lecture) as! NSArray
                let event: NSArray = instruction.value(forKey: StringUtil.event) as! NSArray
                    
                self.instructions = Instruction.iterateJSONArray(instruction, lecture: lecture, event: event)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }) 
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! InstructionCell
        let disc = instructions[ (indexPath as NSIndexPath).row ]
        
        cell.nameLabel.text = disc.lecture.name
        cell.startDateLabel.text = StringUtil.start + DateUtil.date(disc.start_date)
        cell.classeLabel.text = StringUtil.turma + (String(disc.class_number))
        
        let imageBook = ImageUtil.imageDiscipline
        cell.bookImageView.image = imageBook
        cell.bookImageView.tintColor = UIColor.gray

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        instruction = instructions[ (indexPath as NSIndexPath).row ]
        
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
