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
    var refreshControl = UIRefreshControl()
    var instruction = Instruction()
    var material = Material()
    var materials = Array<Material>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = StringUtil.titleMaterial
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView = DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.MaterialTableViewCell, view: view)
        
        refreshControl = DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(InstructionMaterialViewController.getInstructionMaterial), for: UIControlEvents.valueChanged)
        refreshControl.beginRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInstructionMaterial()
    }
    
    func getInstructionMaterial() {
        let request = Server.getRequestNew(Server.url + Server.instructions + "\(instruction.id)" + Server.materials)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let material = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                let person = material.value(forKey: StringUtil.person) as! NSArray
                
                self.materials = Material.iterateJSONArray(material, person: person)
                
                DispatchQueue.main.async(execute: {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                })
            }
        }) 
        task.resume()
    }
    
    func downloadMaterial(_ idMaterial: Int) {
        let request = Server.getRequestNew(Server.url + Server.materials + "\(idMaterial)")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let pdfMaterial = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let url = pdfMaterial.value(forKey: StringUtil.url) as! String
                let material  = pdfMaterial.value(forKey: StringUtil.material) as! NSDictionary
                let name = material.value(forKey: StringUtil.name) as! String
                let mime = material.value(forKey: StringUtil.mime) as! String
                
                let request = Server.getRequestDownloadMaterial(url)
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    if (error != nil) {
                        print(error!.localizedDescription)
                    } else {
                        DispatchQueue.main.async(execute: {
                            DefaultViewController.saveDocumentDirectory(name, data!)
                            
                            if mime.contains(StringUtil.image) {
                                DefaultViewController.pushImageViewController(name, self.navigationController!)
                            } else if mime.contains(StringUtil.applicationPdf) {
                                DefaultViewController.pushPDFViewController(name, self.navigationController!)
                            } else if mime.contains(StringUtil.video) {
                                DefaultViewController.pushVideoPlayerViewController(name, mime, self.navigationController!)
                            }
                        })
                    }
                }
                task.resume()
            }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materials.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! MaterialTableViewCell
        let material = materials[ indexPath.row ]
        
        cell.nameLabel.text = material.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        material = materials[ indexPath.row ]
        
        let fileManager = FileManager.default
        let dataPath = (DefaultViewController.getDirectoryPath() as NSString).appendingPathComponent(material.name)
        if fileManager.fileExists(atPath: dataPath){
            if material.mime.contains(StringUtil.image) {
                DefaultViewController.pushImageViewController(material.name, self.navigationController!)
            } else if material.mime.contains(StringUtil.applicationPdf) {
                DefaultViewController.pushPDFViewController(material.name, self.navigationController!)
            } else if material.mime.contains(StringUtil.video) {
                DefaultViewController.pushVideoPlayerViewController(material.name, material.mime, self.navigationController!)
            }
        } else {
            downloadMaterial(material.id)
        }
    }
    
    init() {
        super.init(nibName: StringUtil.InstructionMaterialViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
