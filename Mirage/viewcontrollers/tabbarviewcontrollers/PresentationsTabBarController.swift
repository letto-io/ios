//
//  PresentationsTabBarController.swift
//  Mirage
//
//  Created by Siena Idea on 20/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class PresentationsTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var idDisc = Discipline().id
    var profileDisc = Discipline().profile
    
    var icon1: UITabBarItem!
    var icon2: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

    }

    override func viewWillAppear(animated: Bool) {
        let item1 = OpenPresentationsViewController()
        item1.idDisc = idDisc
        item1.profileDisc = profileDisc
        
        item1.getPresentation()
        
        let item2  = ClosedPresentationViewController()
        item2.idDisc = idDisc
        item2.profileDisc = profileDisc
        
        item2.getPresentation()
        
        icon1 = UITabBarItem(title: "ABERTAS", image: UIImage(named: "ic_lock_open.png"), selectedImage: UIImage(named: "ic_lock_open.png"))
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: "FECHADAS", image: UIImage(named: "ic_lock_outline.png"), selectedImage: UIImage(named: "ic_lock_outline"))
        item2.tabBarItem = icon2
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.nibName)")
        return true;
    }
    
    init() {
        super.init(nibName: "PresentationsTabBarController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
