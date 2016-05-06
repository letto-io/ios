//
//  DoubtTabBarViewController.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DoubtTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var idDisc = Discipline().id
    var profileDisc = Discipline().profile
    var nameDisc = Discipline().name
    
    var idPresent = Presentation().id
    var subjectPresent = Presentation().subject
    
    var icon1: UITabBarItem!
    var icon2: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationItem.title = "Duvidas"
        
        let item1 = DoubtViewController()
        item1.idDisc = idDisc
        item1.profileDisc = profileDisc
        item1.nameDisc = nameDisc
        item1.idPresent = idPresent
        item1.subjectPresent = subjectPresent
        
        item1.getDoubt()
        
        let item2 = OpenDoubtViewController()
        
        
        icon1 = UITabBarItem(title: "TODAS", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: "ABERTAS", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        
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
        super.init(nibName: "DoubtTabBarViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
