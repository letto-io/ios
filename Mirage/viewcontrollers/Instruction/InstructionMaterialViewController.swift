//
//  InstructionMaterialViewController.swift
//  Mirage
//
//  Created by Oddin on 06/09/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class InstructionMaterialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var material = Material()
    var materials = Array<Material>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = StringUtil.titleMaterial
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        tableView.delegate = self
        tableView.dataSource = self
        getInstructionMaterial()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.MaterialTableViewCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(InstructionViewController.refresh), for: UIControlEvents.valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInstructionMaterial()
    }
    
    // pull to refresh
    func refresh() {
        getInstructionMaterial()
        refreshControl.endRefreshing()
    }
    
    func getInstructionMaterial() {
        let request = Server.getRequestNew(url: Server.url + Server.instructions + "\(instruction.id)" + Server.materials)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let material = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                let person = material.value(forKey: StringUtil.person) as! NSArray
                
                self.materials = Material.iterateJSONArray(material, person: person)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }) 
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materials.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! MaterialTableViewCell
        let material = materials[ (indexPath as NSIndexPath).row ]
        
        cell.nameLabel.text = material.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        material = materials[ (indexPath as NSIndexPath).row ]
        
    }
    
    init() {
        super.init(nibName: StringUtil.InstructionMaterialViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

   

}
