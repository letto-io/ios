//
//  VideoDoubtResponseViewController.swift
//  Mirage
//
//  Created by Oddin on 09/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation

class VideoDoubtResponseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var discipline = Discipline()
    var presentation = Presentation()
    var doubt = Doubt()
    var videoContributions = Array<Contributions>()
    var contributions = Array<Contributions>()
    var contribution = Contributions()
    
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
        
        videoContributions.removeAll()
        
        var auxContributions = Array<Contributions>()
        
        for i in 0 ..< contributions.count {
            var j = 0
            
            if contributions[i].mcmaterial.mime.containsString(StringUtil.video) {
                auxContributions.insert(contributions[i], atIndex: j)
                j += 1
            }
        }
        videoContributions = auxContributions
    }
    
    func downloadContribution(idMaterial: Int) {
        let url = Server.getRequest(Server.presentationURL+"\(discipline.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(doubt.id)" + Server.contribution_bar
            + "\(contribution.id)" + Server.materials_bar + "\(idMaterial)")

        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                
//                let inputStream = NSInputStream(fileAtPath: "/path/to/file/video.mp4")!
//                var buffer = [UInt8](count: data!.length, repeatedValue: 0)
//                data!.getBytes(&buffer, length: data!.length)
//                inputStream.open()
//                inputStream.read(&buffer, maxLength: buffer.count)
//                inputStream.close()
                
                
            }
        })
        task.resume()
        
        let video1 = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let video = NSURL(string: "http://192.168.0.26:3000/system/materials/big_buck_bunny.mp4")
        
        let videoPlayer = AVPlayer(URL: video1!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = videoPlayer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidReachEndNotificationHandler:", name: AVPlayerItemDidPlayToEndTimeNotification, object: videoPlayer.currentItem)
        self.presentViewController(playerViewController, animated: true)
        {
            playerViewController.player!.play()
        }
        
//        
//        let player = AVPlayer(URL: video!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.presentViewController(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoContributions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DoubtResponseTableViewCell
        
        let doubtResponse = videoContributions[ indexPath.row ]
        
        cell.textName.text = doubtResponse.mcmaterial.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        contribution = contributions[ indexPath.row ]
        downloadContribution(contribution.mcmaterial.id)
    }
    
    func loadVideo()
    {
        
    }
    
    init() {
        super.init(nibName: StringUtil.VideoDoubtResponseViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
