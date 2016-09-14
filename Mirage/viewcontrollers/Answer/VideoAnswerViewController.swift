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
import MobileCoreServices

class VideoAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    var videoContributions = Array<Contributions>()
    var contributions = Array<Contributions>()
    var contribution = Contributions()
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
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
        refreshControl.addTarget(self, action: #selector(VideoAnswerViewController.refresh), for: UIControlEvents.valueChanged)
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
        
        videoContributions.removeAll()
        
        var auxContributions = Array<Contributions>()
        
        for i in 0 ..< contributions.count {
            var j = 0
            
//            if contributions[i].mcmaterial.mime.containsString(StringUtil.video) {
//                auxContributions.insert(contributions[i], atIndex: j)
//                j += 1
//            }
        }
        videoContributions = auxContributions
    }
    
    func downloadContribution(_ idMaterial: Int) {
        let url = Server.getRequest(Server.url+"\(instruction.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(question.id)" + Server.contribution_bar
            + "\(contribution.id)" + Server.materials_bar + "\(idMaterial)")

        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {

                
                
            }
        })
        task.resume()
        
        let video1 = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let video = URL(string: "http://192.168.0.26:3000/system/materials/big_buck_bunny.mp4")
        
        let videoPlayer = AVPlayer(url: video1!)
        
        // Find the video in the app's document directory
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[1] as AnyObject
        //let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
        //let videoAsset = (AVAsset(url: URL(fileURLWithPath: dataPath)))
       // let playerItem = AVPlayerItem(asset: videoAsset)
        
        // Play the video
        //let player = AVPlayer(playerItem: playerItem)
        //let playerViewController = AVPlayerViewController()
        //playerViewController.player = player
        
        //self.present(playerViewController, animated: true) {
       //     playerViewController.player!.play()
       // }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoContributions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! AnswerTableViewCell
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contribution = contributions[ (indexPath as NSIndexPath).row ]
        //downloadContribution(contribution.mcmaterial.id)
    }
    
    
    
    init() {
        super.init(nibName: StringUtil.VideoAnswerViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
