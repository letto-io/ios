//
//  PresentationMaterialViewController.swift
//  Mirage
//
//  Created by Oddin on 07/09/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class PresentationMaterialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var presentation = Presentation()
    var material = Material()
    var materials = Array<Material>()
    
    var docController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getPresentationMaterial()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.MaterialTableViewCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(OpenPresentationViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPresentationMaterial()
    }
    
    // pull to refresh
    func refresh() {
        getPresentationMaterial()
        refreshControl.endRefreshing()
    }
    
    func getPresentationMaterial() {
        let request = Server.getRequestNew(url: Server.url + Server.presentations + "\(presentation.id)" + Server.materials)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let material = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                let person = material.value(forKey: StringUtil.person) as! NSArray
                
                print(material)
                
                self.materials = Material.iterateJSONArray(material, person: person)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    
    func getMaterial() {
        let request = Server.getRequestNew(url: Server.url + Server.materials + "\(material.id)")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let download = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let url = download.value(forKey: StringUtil.url) as! String
                let material  = download.value(forKey: StringUtil.material) as! NSDictionary
                let name = material.value(forKey: StringUtil.name) as! String
               
                self.downloadMaterial(url, name: name)
            }
        }
        task.resume()
    }
    
    func downloadMaterial(_ url: String, name: String) {
        let request = Server.getRequestMaterial(url)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let paths = NSSearchPathForDirectoriesInDomains(
                    FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let documentsDirectory: AnyObject = paths[0] as AnyObject
                //let dataPath = documentsDirectory.appendingPathComponent(name)
                //try? data?.write(to: URL(fileURLWithPath: dataPath), options: [])
                
            }
        }
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
        
       getMaterial()
    }
    
    init() {
        super.init(nibName: StringUtil.openPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
