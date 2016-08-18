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
        DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.doubtCell, view: view)
        
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
            
            print(question  )
            }
        }
        task.resume()
    
        orderedQuestions.removeAll()

        var auxDoubt = Array<Question>()

        for i in 0 ..< questions.count {
            var j = 0
            auxDoubt.insert(questions[i], atIndex: j)
            j += 1
        }
        orderedQuestions = auxDoubt.sort({ $0.created_at > $1.created_at })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedQuestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! DoubtTableViewCell
        
        let doubt = orderedQuestions[ indexPath.row ]
        
        if doubt.anonymous == false {
            cell.nameLabel.text = doubt.person.name
        } else {
            cell.nameLabel.text = StringUtil.anonimo
        }
        cell.textDoubtLabel.text = doubt.text
        cell.hourLabel.text = DateUtil.hour(doubt.created_at)
        cell.countLikesLabel.text = String(doubt.upvotes)
        cell.likeButton.setImage(ImageUtil.imageLikeButton, forState: .Normal)
        cell.likeButton.tintColor = ColorUtil.orangeColor
        
//        if instruction.profile == 2 {
//            cell.likeButton.enabled = false
//            if doubt.status == 2 {
//                cell.closeDoubt.setImage(ImageUtil.imageCloseDoubt, forState: .Normal)
//            } else {
//                cell.closeDoubt.setImage(ImageUtil.imageOpenDoubt, forState: .Normal)
//            }
//            cell.closeDoubt.tintColor = UIColor.grayColor()
//        }
//        
//        if doubt.contributions >= 1 {
//            let imageAnswer = ImageUtil.imageAnswer
//            cell.answerImageView.image = imageAnswer
//            cell.answerImageView.tintColor = UIColor.grayColor()
//        }
        
        //passagem de id para url de like na dúvida
        cell.likeButton.tag = orderedQuestions[ indexPath.row ].id
        
        if doubt.my_vote == 0 {
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
        
        let doubtsResponse = DoubtsResponseTabBarViewController()
        doubtsResponse.instruction = instruction
        doubtsResponse.presentation = presentation
        doubtsResponse.question = question
    
        self.navigationController?.pushViewController(doubtsResponse, animated: true)
    }
    
    func likeButtonPressed(sender: UIButton) {
        let request = Server.postResquestNotSendCookie(Server.presentationURL+"\(instruction.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(sender.tag)" + Server.like)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                    let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                    
                    if httpResponse.statusCode == 404 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                        })
                    } else if httpResponse.statusCode == 401 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgNotRankYourDoubt), animated: true, completion: nil)
                        })
                    } else if httpResponse.statusCode == 200 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.viewDidAppear(true)
                        })
                    }
                }
                print(response)
            }
        }
        task.resume()
    }
    
    func deleteLikeButtonPressed(sender: UIButton) {
        let request = Server.deleteRequest(Server.presentationURL+"\(instruction.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt_bar + "\(sender.tag)" + Server.like)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                    let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                    
                    if httpResponse.statusCode == 404 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                        })
                    } else if httpResponse.statusCode == 401 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgNotRankYourDoubt), animated: true, completion: nil)
                        })
                    } else if httpResponse.statusCode == 200 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.viewDidAppear(true)
                        })
                    }
                }
                print(response)
            }
        }
        task.resume()
    }
    
    init() {
        super.init(nibName: StringUtil.QuestionViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
