//
//  DoubtTabBarViewController.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class QuestionsTabBarViewController: UITabBarController, UITabBarControllerDelegate, AddNewDoubtDelegate {
    
    var instruction = Instruction()
    var presentation = Presentation()
    var questions = Array<Question>()
    var teacherMenuButton = UIBarButtonItem()
    var studentMenuButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = presentation.subject
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target:nil, action:nil)
        
        let item1 = question()
        let item2 = rankingQuestion()
        let item3 = openQuestion()
        let item4 = closedQuestion()
        
        let icon1 = UITabBarItem(title: StringUtil.all, image: ImageUtil.imageAllBlack, selectedImage: ImageUtil.imageAllWhite)
        item1.tabBarItem = icon1
        let icon2 = UITabBarItem(title: StringUtil.ranking, image: ImageUtil.imageRankingBlack, selectedImage: ImageUtil.imageRankingWhite)
        item2.tabBarItem = icon2
        let icon3 = UITabBarItem(title: StringUtil.open, image: ImageUtil.imageOpenBlack, selectedImage: ImageUtil.imageOpenWhite)
        item3.tabBarItem = icon3
        let icon4 = UITabBarItem(title: StringUtil.closed, image: ImageUtil.imageClosedBlack, selectedImage: ImageUtil.imageClosedWhite)
        item4.tabBarItem = icon4
        
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        //verifica se é um perfil de aluno para postar novas duvidas e se a apresentação esta aberta
        if instruction.profile == 0 && presentation.status == 0 {
            studentMenuButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(QuestionsTabBarViewController.menuStudent))
            studentMenuButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButton(studentMenuButton, animated: true)
        } else if instruction.profile == 0 && presentation.status == 1 {
            studentMenuButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(QuestionsTabBarViewController.menuStudentNotCreateQuestion))
            studentMenuButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButton(studentMenuButton, animated: true)
        }else if instruction.profile == 1 {
            teacherMenuButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(QuestionsTabBarViewController.menuTeacher))
            teacherMenuButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButton(teacherMenuButton, animated: true)
        }
    }
    
    func question() -> QuestionViewController {
        let item1 = QuestionViewController()
        item1.instruction = instruction
        item1.presentation = presentation
        
        return item1
    }
    
    func rankingQuestion() -> RankingQuestionViewController {
        let item4 = RankingQuestionViewController()
        item4.instruction = instruction
        item4.presentation = presentation
        
        return item4
    }
    
    func openQuestion() -> OpenQuestionViewController {
        let item2 = OpenQuestionViewController()
        item2.instruction = instruction
        item2.presentation = presentation
        
        return item2
    }
    
    func closedQuestion() -> ClosedQuestionViewController {
        let item3 = ClosedQuestionViewController()
        item3.instruction = instruction
        item3.presentation = presentation
        
        return item3
    }
    
    func menuTeacher() {
        let myAlert = UIAlertController(title: presentation.subject, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let downloadMaterialAction: UIAlertAction = UIAlertAction(title: StringUtil.download, style: .default) { action -> Void in
            let material = PresentationMaterialViewController()
            material.presentation = self.presentation
            
            self.navigationController?.pushViewController(material, animated: true)
        }
        
        let uploadMaterialAction: UIAlertAction = UIAlertAction(title: StringUtil.upload, style: .default) { action -> Void in
            
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .cancel) { action -> Void in
            
        }
        
        myAlert.addAction(downloadMaterialAction)
        myAlert.addAction(uploadMaterialAction)
        myAlert.addAction(cancelAction)
        
        if let popoverController = myAlert.popoverPresentationController {
            popoverController.barButtonItem = teacherMenuButton
        }
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func menuStudent() {
        let myAlert = UIAlertController(title: presentation.subject, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let createQuestionAction: UIAlertAction = UIAlertAction(title: StringUtil.newQuestionTitle, style: .default) { action -> Void in
            let newDoubt = CreateQuestionViewController(delegate: self)
            newDoubt.instruction = self.instruction
            newDoubt.presentation = self.presentation
            
            self.navigationController?.pushViewController(newDoubt, animated: true)
        }
        
        let downloadMaterialAction: UIAlertAction = UIAlertAction(title: StringUtil.download, style: .default) { action -> Void in
            let material = PresentationMaterialViewController()
            material.presentation = self.presentation
            
            self.navigationController?.pushViewController(material, animated: true)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .cancel) { action -> Void in
            
        }
        
        myAlert.addAction(createQuestionAction)
        myAlert.addAction(downloadMaterialAction)
        myAlert.addAction(cancelAction)
        
        if let popoverController = myAlert.popoverPresentationController {
            popoverController.barButtonItem = studentMenuButton
        }
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func menuStudentNotCreateQuestion() {
        let myAlert = UIAlertController(title: presentation.subject, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let downloadMaterialAction: UIAlertAction = UIAlertAction(title: StringUtil.download, style: .default) { action -> Void in
            let material = PresentationMaterialViewController()
            material.presentation = self.presentation
            
            self.navigationController?.pushViewController(material, animated: true)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .cancel) { action -> Void in
            
        }
        
        myAlert.addAction(downloadMaterialAction)
        myAlert.addAction(cancelAction)
        
        if let popoverController = myAlert.popoverPresentationController {
            popoverController.barButtonItem = studentMenuButton
        }
        
        self.present(myAlert, animated: true, completion: nil)
    }

    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
    
    init() {
        super.init(nibName: StringUtil.QuestionsTabBarViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
