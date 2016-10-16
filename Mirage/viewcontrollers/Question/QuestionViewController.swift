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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getQuestion()
        tableView = DefaultViewController.refreshTableView(tableView, cellNibName: StringUtil.QuestionTableViewCell, view: view)
        
        refreshControl = UIRefreshControl()
        refreshControl = DefaultViewController.refreshControl(refreshControl, tableView: tableView)
        refreshControl.addTarget(self, action: #selector(QuestionViewController.refresh), for: UIControlEvents.valueChanged)
        refreshControl.beginRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getQuestion()
    }

    // pull to refresh
    func refresh() {
        getQuestion()
        refreshControl.endRefreshing()
    }
    
    func getQuestion() {
        let request = Server.getRequestNew(Server.url + Server.presentations + "\(presentation.id)" + Server.questions)
            
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                let question = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                let presentation = question.value(forKey: StringUtil.presentation) as! NSArray
                let person = question.value(forKey: StringUtil.person) as! NSArray
                
                self.questions = Question.iterateJSONArray(question, presentation: presentation, person: person)
                self.questions.sort(by: { $0.created_at > $1.created_at })

                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringUtil.cell, for: indexPath) as! QuestionTableViewCell
        
        let question = questions[ indexPath.row ]
        
        if question.anonymous == false {
            cell.nameLabel.text = question.person.name
        } else {
            cell.nameLabel.text = StringUtil.anonimo
        }
        cell.textDoubtLabel.text = question.text
        cell.hourLabel.text = DateUtil.hour(question.created_at)
        cell.countLikesLabel.text = String(question.upvotes)
        cell.likeButton.setImage(ImageUtil.imageLikeButton, for: UIControlState())
        cell.likeButton.tintColor = ColorUtil.orangeColor
        
        if instruction.profile == 1 {
            cell.likeButton.isEnabled = false
        }

        if question.has_answer == true && question.answered == false{
            let imageAnswer = ImageUtil.imageAnswer
            cell.answerImageView.image = imageAnswer
            cell.answerImageView.tintColor = UIColor.gray
        } else if question.has_answer == true && question.answered == true {
            let imageAnswered = ImageUtil.imageAnswered
            cell.answerImageView.image = imageAnswered
            cell.answerImageView.tintColor = UIColor.orange
        } else {
            cell.answerImageView.image = nil
        }
        
        //passagem de id para url de like na dúvida
        cell.likeButton.tag = questions[ indexPath.row ].id
        
        if question.my_vote == 0 {
            cell.likeButton.addTarget(self, action: #selector(QuestionViewController.likeButtonPressed), for: .touchUpInside)
            cell.likeButton.setImage(ImageUtil.imageLikeButton, for: UIControlState())
            cell.likeButton.tintColor = UIColor.gray
        } else {
            cell.likeButton.addTarget(self, action: #selector(QuestionViewController.deleteLikeButtonPressed), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        question = questions[ indexPath.row ]
        
        let answer = AnswersTabBarViewController()
        answer.instruction = instruction
        answer.presentation = presentation
        answer.question = question
    
        self.navigationController?.pushViewController(answer, animated: true)
    }
    
    func likeButtonPressed(_ sender: UIButton) {
        let request = Server.postRequestSendToken(Server.url + Server.questions + "\(sender.tag)" + Server.upvote)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
                return
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 404 {
                        DispatchQueue.main.async(execute: {
                            self.present(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                        })
                    } else if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async(execute: {
                            self.getQuestion()
                        })
                    }
                }
            }
        }
        task.resume()
        
    }
    
    func deleteLikeButtonPressed() {
        self.present(DefaultViewController.alertMessage(StringUtil.msgQuestionRanked), animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: StringUtil.QuestionViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
