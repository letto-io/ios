//
//  AudioDoubtResponseViewController.swift
//  Mirage
//
//  Created by Oddin on 09/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class AudioAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    var audioContributions = Array<Contributions>()
    var contributions = Array<Contributions>()
    
    func tableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        getDoubtResponse()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViews()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.AnswerCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(AudioAnswerViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableViews()
    }
    
    // pull to refresh
    func refresh() {
        getDoubtResponse()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getDoubtResponse() {
        let request = Server.getRequestNew(url: Server.url + Server.presentations + "\(presentation.id)" + Server.materials)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let material = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                
                //print(material)
                
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.tableView.reloadData()
//                    
//                })
            }
        }
        task.resume()
        
        audioContributions.removeAll()
        
        var auxContributions = Array<Contributions>()
        
        for i in 0 ..< contributions.count {
            var j = 0
            
//            if contributions[i].mcmaterial.mime.containsString(StringUtil.audio) {
//                auxContributions.insert(contributions[i], atIndex: j)
//                j += 1
//            }
        }
        audioContributions = auxContributions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioContributions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! AnswerTableViewCell
        
        
        
        return cell
    }
    
    init() {
        super.init(nibName: StringUtil.AudioAnswerViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
