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

class VideoAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    var materialAnswers = Array<Material>()
    var videoMaterialAnswers = Array<Material>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView = DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.AnswerTableViewCell, view: view)
        
        refreshControl = UIRefreshControl()
        refreshControl = DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(VideoAnswerViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAnswer()
    }
    
    // pull to refresh
    func refresh() {
        getAnswer()
        refreshControl.endRefreshing()
    }
    
    func getAnswer() {
        let request = Server.getRequestNew(Server.url + Server.questions + "\(question.id)" + Server.answers)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let answerMaterial = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                
                self.materialAnswers = Material.iterateJSONArray(answerMaterial)
                
                self.videoMaterialAnswers.removeAll()
                
                var auxMaterial = Array<Material>()
                
                for i in 0 ..< self.materialAnswers.count {
                    var j = 0
                    
                    if self.materialAnswers[i].mime.contains(StringUtil.video) {
                        auxMaterial.insert(self.materialAnswers[i], at: j)
                        j += 1
                    }
                }
                self.videoMaterialAnswers = auxMaterial
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
        task.resume()
    }
    
    func downloadVideo(_ idMaterial: Int) {
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
                            
                            if mime.contains(StringUtil.video) {
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
        return videoMaterialAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! AnswerTableViewCell
        
        let material = videoMaterialAnswers[ indexPath.row ]
        
        cell.nameLabel.text = material.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videoMaterialAnswers[ indexPath.row ]
        
        let fileManager = FileManager.default
        let dataPath = (DefaultViewController.getDirectoryPath() as NSString).appendingPathComponent(video.name)
        if fileManager.fileExists(atPath: dataPath) {
            DefaultViewController.pushVideoPlayerViewController(video.name, video.mime, self.navigationController!)
        } else {
            downloadVideo(video.id)
        }
    }
    
    init() {
        super.init(nibName: StringUtil.VideoAnswerViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
