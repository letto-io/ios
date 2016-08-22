//
//  DoubtViewController.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var instruction = Instruction()
    var presentation = Presentation()
    var question = Question()
    var questions = Array<Question>()
    var orderedQuestions = Array<Question>()
    
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
        refreshControl.addTarget(self, action: #selector(QuestionViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
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
    
        orderedQuestions.removeAll()

        var auxQuestion = Array<Question>()

        for i in 0 ..< questions.count {
            var j = 0
            auxQuestion.insert(questions[i], atIndex: j)
            j += 1
        }
        orderedQuestions = auxQuestion.sort({ $0.created_at > $1.created_at })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedQuestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cell, forIndexPath: indexPath) as! QuestionCell
        
        let question = orderedQuestions[ indexPath.row ]
        
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
        
        if instruction.profile == 1 {
            cell.likeButton.enabled = false
        }

        if question.has_answer == true && question.answered == false{
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
        cell.likeButton.tag = orderedQuestions[ indexPath.row ].id
        
        if question.my_vote == 0 {
            cell.likeButton.addTarget(self, action: #selector(QuestionViewController.likeButtonPressed), forControlEvents: .TouchUpInside)
            cell.likeButton.setImage(ImageUtil.imageLikeButton, forState: .Normal)
            cell.likeButton.tintColor = UIColor.grayColor()
        } else {
            cell.likeButton.addTarget(self, action: #selector(QuestionViewController.deleteLikeButtonPressed), forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        question = orderedQuestions[ indexPath.row ]
        
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
        super.init(nibName: StringUtil.QuestionViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
