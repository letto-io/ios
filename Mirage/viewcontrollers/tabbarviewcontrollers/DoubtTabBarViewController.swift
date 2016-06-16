//
//  DoubtTabBarViewController.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DoubtTabBarViewController: UITabBarController, UITabBarControllerDelegate, AddNewDoubtDelegate {
    
    var discipline = Discipline()
    var presentation = Presentation()
    var icon1: UITabBarItem!
    var icon2: UITabBarItem!
    var icon3: UITabBarItem!
    var icon4: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationItem.title = StringUtil.doubtTitle
        
        //verifica se é um perfil de aluno para postar novas duvidas
        if discipline.profile == 0 {
            
            let newDoubtButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(DoubtTabBarViewController.showNewDoubt))
            
            newDoubtButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButtonItem(newDoubtButton, animated: true)
        }
        
        let item1 = DoubtViewController()
        item1.discipline.id = discipline.id
        item1.discipline.profile = discipline.profile
        item1.discipline.name = discipline.name
        item1.presentation.id = presentation.id
        item1.presentation.subject = presentation.subject
        item1.getDoubt()
        
        let item2 = OpenDoubtViewController()
        item2.discipline.id = discipline.id
        item2.discipline.profile = discipline.profile
        item2.discipline.name = discipline.name
        item2.presentation.id = presentation.id
        item2.presentation.subject = presentation.subject
        item2.getDoubt()
        
        let item3 = ClosedDoubtViewController()
        item3.discipline.id = discipline.id
        item3.discipline.profile = discipline.profile
        item3.discipline.name = discipline.name
        item3.presentation.id = presentation.id
        item3.presentation.subject = presentation.subject
        item3.getDoubt()
        
        let item4 = RankingDoubtViewController()
        item4.discipline.id = discipline.id
        item4.discipline.profile = discipline.profile
        item4.discipline.name = discipline.name
        item4.presentation.id = presentation.id
        item4.presentation.subject = presentation.subject
        item4.getDoubt()
        
        icon1 = UITabBarItem(title: StringUtil.all, image: ImageUtil.imageAllBlack, selectedImage: ImageUtil.imageAllWhite)
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: StringUtil.open, image: ImageUtil.imageOpenBlack, selectedImage: ImageUtil.imageOpenWhite)
        item2.tabBarItem = icon2
        icon3 = UITabBarItem(title: StringUtil.closed, image: ImageUtil.imageClosedBlack, selectedImage: ImageUtil.imageClosedWhite)
        item3.tabBarItem = icon3
        icon4 = UITabBarItem(title: StringUtil.ranking, image: ImageUtil.imageRankingBlack, selectedImage: ImageUtil.imageRankingWhite)
        item4.tabBarItem = icon4
        
        var menuButton = UIBarButtonItem()
        
        if self.revealViewController() != nil {
            
            menuButton = UIBarButtonItem(image: ImageUtil.imageMenuButton, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        let back = UIBarButtonItem(image: ImageUtil.imageBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DoubtTabBarViewController.back))
        self.navigationItem.setLeftBarButtonItems([menuButton, back], animated: true)
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //postar nova duvida
    func showNewDoubt() {
        
        let newDoubt = CreateNewDoubtViewController(delegate: self)
        
        newDoubt.discipline.id = discipline.id
        newDoubt.presentation.id = presentation.id
        
        self.navigationController?.pushViewController(newDoubt, animated: true)
    }

    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print(viewController.nibName)
        return true;
    }
    
    init() {
        super.init(nibName: StringUtil.doubtTabBarViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
