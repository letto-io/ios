//
//  PresentationsTabBarController.swift
//  Mirage
//
//  Created by Siena Idea on 20/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class PresentationsTabBarController: UITabBarController, UITabBarControllerDelegate, AddNewPresentationDelegate {
    var instruction = Instruction()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = instruction.lecture.name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        let item1 = openPresentation()
        let item2  = closedPresentation()
        
        let icon1 = UITabBarItem(title: StringUtil.open, image: ImageUtil.imageOpenBlack , selectedImage: ImageUtil.imageOpenWhite)
        item1.tabBarItem = icon1
        let icon2 = UITabBarItem(title: StringUtil.closed, image: ImageUtil.imageClosedBlack, selectedImage: ImageUtil.imageClosedWhite)
        item2.tabBarItem = icon2
        
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        //verifica se é um perfil de professor para criar novas apresentações
//        if discipline.profile == 2 {
//            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(OpenPresentationViewController.longPress(_:)))
//            self.view.addGestureRecognizer(longPressRecognizer)
//            
//            let newPresentationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(PresentationsTabBarController.showNewPresentation))
//            newPresentationButton.tintColor = ColorUtil.orangeColor
//            
//            self.navigationItem.setRightBarButtonItem(newPresentationButton, animated: true)
//        }
    }
    
    func openPresentation() -> OpenPresentationViewController {
        let item1 = OpenPresentationViewController()
        item1.instruction = instruction
        item1.getPresentation()
        
        return item1
    }
    
    func closedPresentation() -> ClosedPresentationViewController {
        let item2  = ClosedPresentationViewController()
        item2.instruction = instruction
        item2.getPresentation()
        
        return item2
    }
    
    //cadastrar nova apresentação
    func showNewPresentation() {
        let newPresentation = CreateNewPresentationViewController(delegate: self)
        newPresentation.instruction = instruction
        
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
