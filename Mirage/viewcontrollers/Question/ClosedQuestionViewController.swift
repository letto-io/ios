//
//  ClosedDoubtViewController.swift
//  Mirage
//
//  Created by Siena Idea on 11/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ClosedQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    var questions  = Array<Question>()
    var closedQuestions  = Array<Question>()
    
    func tableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        getDoubt()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViews()
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.QuestionCell, view: view)
        
        refreshControl = UIRefreshControl()
        DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(ClosedQuestionViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableViews()
    }
    
    // pull to refresh
    func refresh() {
        getDoubt()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getDoubt() {
        let request = Server.getRequestNew(Server.url + Server.presentations + "\(presentation.id)" + Server.questions)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let question = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                let presentation = question.valueForKey(StringUtil.presentation) as! NSArray
                let person = question.valueForKey(StringUtil.person) as! NSArray
                
                self.questions = Question.iterateJSONArray(question, presentation: presentation, person: person)
            }
        }
        task.resume()
        
        closedQuestions.removeAll()
        
        var auxQuestion = Array<Question>()
        
        for i in 0 ..< questions.count {
            var j = 0
            
            if questions[i].answered == true {
                auxQuestion.insert(questions[i], atIndex: j)
                j += 1
            }
        }
        closedQuestions = auxQuestion.sort({ $0.created_at > $1.created_at })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closedQuestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cell, forIndexPath: indexPath) as! QuestionCell
        
        let question = closedQuestions[ indexPath.row ]
        
        if question.anonymous == false {
            cell.nameLabel.text = question.person.name
        } else {
            cell.nameLabel.text = StringUtil.anonimo
        }
        cell.textDoubtLabel.text = question.text
        cell.hourLabel.text = DateUtil.hour(question.created_at)
        cell.countLikesLabel.text = String(question.upvotes)
        cell.likeButton.setImage(ImageUtil.imageLikeButton, forState: .Normal)
        cell.likeButton.tintColor = ColorUtil.orangeColor
        
        if instruction.profile == 1 || question.answered == true {
            cell.likeButton.enabled = false
        }
        
        if question.has_answer == true && question.answered == false {
            let imageAnswer = ImageUtil.imageAnswer
            cell.answerImageView.image = imageAnswer
            cell.answerImageView.tintColor = UIColor.grayColor()
        } else if question.has_answer == true && question.answered == true {
            let imageAnswered = ImageUtil.imageAnswered
            cell.answerImageView.image = imageAnswered
            cell.answerImageView.tintColor = UIColor.orangeColor()
        } else {
            cell.answerImageView.image = nil
        }
        
        //passagem de id para url de like na dúvida
        cell.likeButton.tag = closedQuestions[ indexPath.row ].id
        
        if question.my_vote == 0 {
            cell.likeButton.addTarget(self, action: #selector(ClosedQuestionViewController.likeButtonPressed), forControlEvents: .TouchUpInside)
            cell.likeButton.setImage(ImageUtil.imageLikeButton, forState: .Normal)
            cell.likeButton.tintColor = UIColor.grayColor()
        } else {
            cell.likeButton.addTarget(self, action: #selector(ClosedQuestionViewController.deleteLikeButtonPressed), forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        question = closedQuestions[ indexPath.row ]
        
        let answer = AnswersTabBarViewController()
        answer.instruction = instruction
        answer.presentation = presentation
        answer.question = question
        
        self.navigationController?.pushViewController(answer, animated: true)
    }
    
    func likeButtonPressed(sender: UIButton) {
        let request = Server.postRequestSendToken(Server.url + Server.questions + "\(sender.tag)" + Server.upvote)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 404 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                        })
                    } else if httpResponse.statusCode == 200 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.viewDidAppear(true)
                        })
                    }
                }
            }
        }
        task.resume()
        
        self.viewDidAppear(true)
    }
    
    func deleteLikeButtonPressed() {
        self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgQuestionRanked), animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: StringUtil.ClosedQuestionViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
