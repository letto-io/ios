//
//  TextDoubtReponseViewController.swift
//  Mirage
//
//  Created by Oddin on 08/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class TextAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    var textAnswers = Array<Answer>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getAnswer()
        tableView = DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.TextAnswerTableViewCell, view: view)
        
        refreshControl = UIRefreshControl()
        refreshControl = DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(TextAnswerViewController.refresh), for: UIControlEvents.valueChanged)
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
                let answer = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                
                self.textAnswers = Answer.iterateJSONArray(answer)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }) 
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! TextAnswerTableViewCell
        
        let answer = textAnswers[ (indexPath as NSIndexPath).row ]
        
        if instruction.profile == 1 {
            cell.upvoteButton.isEnabled = false
            cell.downvoteButton.isEnabled = false
            cell.acceptButton.isEnabled = false
        }
        
        cell.textAnswerLabel.text = answer.text
        cell.countVotesLabel.text = String(answer.upvotes)
        
        cell.upvoteButton.setImage(ImageUtil.imageUpvote, for: UIControlState())
        cell.upvoteButton.tintColor = UIColor.gray
        
        cell.downvoteButton.setImage(ImageUtil.imageDownvote, for: UIControlState())
        cell.downvoteButton.tintColor = UIColor.gray
        
        cell.acceptButton.setImage(ImageUtil.imageAccept, for: UIControlState())
        cell.acceptButton.tintColor = UIColor.gray
        
        if answer.accepted == true {
            cell.acceptButton.setImage(ImageUtil.imageAccept, for: UIControlState())
            cell.acceptButton.tintColor = UIColor.green
        }
        
        return cell
    }
    
    init() {
        super.init(nibName: StringUtil.TextAnswerViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
