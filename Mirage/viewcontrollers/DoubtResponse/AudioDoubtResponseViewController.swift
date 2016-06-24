//
//  AudioDoubtResponseViewController.swift
//  Mirage
//
//  Created by Oddin on 09/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class AudioDoubtResponseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var discipline = Discipline()
    var presentation = Presentation()
    var doubt = Doubt()
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
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.doubtResponseCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(AudioDoubtResponseViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableViews()
    }
    
    // pull to refresh
    func refresh() {
        getDoubtResponse()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getDoubtResponse() {
        let url = Server.getRequest(Server.presentationURL+"\(discipline.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(doubt.id)" + Server.contribution)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let doubtResponseJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                
                if (doubtResponseJSONData.valueForKey(StringUtil.error) != nil) {
                    return
                } else {
                    let contributions : NSArray = doubtResponseJSONData.valueForKey(StringUtil.contributions) as! NSArray
                    let mcmaterials : NSArray = contributions.valueForKey(StringUtil.mcmaterial) as! NSArray
                    let persons : NSArray = contributions.valueForKey(StringUtil.person) as! NSArray
                    
                    self.contributions = Contributions.iterateJSONArray(contributions, mcmaterials: mcmaterials, persons: persons)
                }
                print(doubtResponseJSONData)
            }
        })
        task.resume()
        
        audioContributions.removeAll()
        
        var auxContributions = Array<Contributions>()
        
        for i in 0 ..< contributions.count {
            var j = 0
            
            if contributions[i].mcmaterial.mime.containsString(StringUtil.audio) {
                auxContributions.insert(contributions[i], atIndex: j)
                j += 1
            }
        }
        audioContributions = auxContributions
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioContributions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DoubtResponseTableViewCell
        
        let doubtResponse = audioContributions[ indexPath.row ]
        
        cell.textName.text = doubtResponse.mcmaterial.name
        
        return cell
    }
    
    init() {
        super.init(nibName: StringUtil.AudioDoubtResponseViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
