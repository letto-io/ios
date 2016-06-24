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
    var doubts = Array<Doubt>()
    var icon1: UITabBarItem!
    var icon2: UITabBarItem!
    var icon3: UITabBarItem!
    var icon4: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = presentation.subject
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.Plain, target:nil, action:nil)
        
        //verifica se é um perfil de aluno para postar novas duvidas
        if discipline.profile == 0 {
            let newDoubtButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(DoubtTabBarViewController.showNewDoubt))
            newDoubtButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButtonItem(newDoubtButton, animated: true)
        }
        
        let item1 = DoubtViewController()
        item1.discipline = discipline
        item1.presentation = presentation
        //item1.getDoubt()
        
        let item2 = OpenDoubtViewController()
        item2.discipline = discipline
        item2.presentation = presentation
        item2.getDoubt()
        
        let item3 = ClosedDoubtViewController()
        item3.discipline = discipline
        item3.presentation = presentation
        item3.getDoubt()
        
        let item4 = RankingDoubtViewController()
        item4.discipline = discipline
        item4.presentation = presentation
        item4.getDoubt()
        
        icon1 = UITabBarItem(title: StringUtil.all, image: ImageUtil.imageAllBlack, selectedImage: ImageUtil.imageAllWhite)
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: StringUtil.open, image: ImageUtil.imageOpenBlack, selectedImage: ImageUtil.imageOpenWhite)
        item2.tabBarItem = icon2
        icon3 = UITabBarItem(title: StringUtil.closed, image: ImageUtil.imageClosedBlack, selectedImage: ImageUtil.imageClosedWhite)
        item3.tabBarItem = icon3
        icon4 = UITabBarItem(title: StringUtil.ranking, image: ImageUtil.imageRankingBlack, selectedImage: ImageUtil.imageRankingWhite)
        item4.tabBarItem = icon4
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    //postar nova duvida
    func showNewDoubt() {
        let newDoubt = CreateNewDoubtViewController(delegate: self)
        newDoubt.discipline = discipline
        newDoubt.presentation = presentation
        
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
