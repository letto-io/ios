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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = presentation.subject
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.Plain, target:nil, action:nil)
        
        let item1 = question()
        let item2 = openQuestion()
        let item3 = closedQuestion()
        let item4 = rankingQuestion()
        
        
        let icon1 = UITabBarItem(title: StringUtil.all, image: ImageUtil.imageAllBlack, selectedImage: ImageUtil.imageAllWhite)
        item1.tabBarItem = icon1
        let icon2 = UITabBarItem(title: StringUtil.open, image: ImageUtil.imageOpenBlack, selectedImage: ImageUtil.imageOpenWhite)
        item2.tabBarItem = icon2
        let icon3 = UITabBarItem(title: StringUtil.closed, image: ImageUtil.imageClosedBlack, selectedImage: ImageUtil.imageClosedWhite)
        item3.tabBarItem = icon3
        let icon4 = UITabBarItem(title: StringUtil.ranking, image: ImageUtil.imageRankingBlack, selectedImage: ImageUtil.imageRankingWhite)
        item4.tabBarItem = icon4
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        //verifica se é um perfil de aluno para postar novas duvidas
        if instruction.profile == 0 {
            let newDoubtButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(QuestionsTabBarViewController.createQuestion))
            newDoubtButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButtonItem(newDoubtButton, animated: true)
        }
    }
    
    func question() -> QuestionViewController {
        let item1 = QuestionViewController()
        item1.instruction = instruction
        item1.presentation = presentation
        item1.getDoubt()
        
        return item1
    }
    
    func openQuestion() -> OpenQuestionViewController {
        let item2 = OpenQuestionViewController()
        item2.instruction = instruction
        item2.presentation = presentation
        item2.getDoubt()
        
        return item2
    }
    
    func closedQuestion() -> ClosedQuestionViewController {
        let item3 = ClosedQuestionViewController()
        item3.instruction = instruction
        item3.presentation = presentation
        item3.getDoubt()
        
        return item3
    }
    
    func rankingQuestion() -> RankingQuestionViewController {
        let item4 = RankingQuestionViewController()
        item4.instruction = instruction
        item4.presentation = presentation
        item4.getDoubt()
        
        return item4
    }
    
    //postar nova duvida
    func createQuestion() {
        let newDoubt = CreateQuestionViewController(delegate: self)
        newDoubt.instruction = instruction
        newDoubt.presentation = presentation
        
        self.navigationController?.pushViewController(newDoubt, animated: true)
    }

    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true;
    }
    
    init() {
        super.init(nibName: StringUtil.QuestionsTabBarViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
