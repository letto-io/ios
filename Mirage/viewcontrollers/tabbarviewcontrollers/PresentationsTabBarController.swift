//
//  PresentationsTabBarController.swift
//  Mirage
//
//  Created by Siena Idea on 20/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class PresentationsTabBarController: UITabBarController, UITabBarControllerDelegate, AddNewPresentationDelegate {
    
    var icon1: UITabBarItem!
    var icon2: UITabBarItem!
    var discipline = Discipline()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = discipline.name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        //verifica se é um perfil de professor para criar novas apresentações
        if discipline.profile == 2 {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(OpenPresentationViewController.longPress(_:)))
            self.view.addGestureRecognizer(longPressRecognizer)

            let newPresentationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(PresentationsTabBarController.showNewPresentation))
            newPresentationButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButtonItem(newPresentationButton, animated: true)
        }
        
        let item1 = OpenPresentationViewController()
        item1.discipline = discipline
        item1.getPresentation()
        
        let item2  = ClosedPresentationViewController()
        item2.discipline = discipline
        item2.getPresentation()
        
        icon1 = UITabBarItem(title: StringUtil.open, image: ImageUtil.imageOpenBlack , selectedImage: ImageUtil.imageOpenWhite)
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: StringUtil.closed, image: ImageUtil.imageClosedBlack, selectedImage: ImageUtil.imageClosedWhite)
        item2.tabBarItem = icon2
        
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    //cadastrar nova apresentação
    func showNewPresentation() {
        let newPresentation = CreateNewPresentationViewController(delegate: self)
        newPresentation.discipline = discipline
        
        self.navigationController?.pushViewController(newPresentation, animated: true)
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print(viewController.nibName)
        return true;
    }
    
    init() {
        super.init(nibName: StringUtil.presentationsTabBarController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
