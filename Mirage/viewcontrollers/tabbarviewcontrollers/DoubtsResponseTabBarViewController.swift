//
//  DoubtsResponseTabBarViewController.swift
//  Mirage
//
//  Created by Oddin on 06/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DoubtsResponseTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var discipline = Discipline()
    var presentation = Presentation()
    var doubt = Doubt()
    
    var icon1: UITabBarItem!
    var icon2: UITabBarItem!
    var icon3: UITabBarItem!
    var icon4: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    override func viewWillAppear(animated: Bool) {

        let item1  = TextDoubtReponseViewController()
        item1.discipline.id = discipline.id
        item1.presentation.id = presentation.id
        item1.doubt.id = doubt.id
        item1.getDoubtResponse()
        
        let item2 = AudioDoubtResponseViewController()
        item2.discipline.id = discipline.id
        item2.presentation.id = presentation.id
        item2.doubt.id = doubt.id
        item2.getDoubtResponse()
        
        let item3 = VideoDoubtResponseViewController()
        item3.discipline.id = discipline.id
        item3.presentation.id = presentation.id
        item3.doubt.id = doubt.id
        item3.getDoubtResponse()
        
        let item4 = AttachmentDoubtResponseViewController()
        item4.discipline.id = discipline.id
        item4.presentation.id = presentation.id
        item4.doubt.id = doubt.id
        item4.getDoubtResponse()
        
        icon1 = UITabBarItem(title: StringUtil.Texto, image: ImageUtil.imageTextBlack, selectedImage: ImageUtil.imageTextWhite)
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: StringUtil.Audio, image: ImageUtil.imageAudioBlack, selectedImage: ImageUtil.imageAudioWhite)
        item2.tabBarItem = icon2
        icon3 = UITabBarItem(title: StringUtil.Video, image: ImageUtil.imageVideoBlack, selectedImage: ImageUtil.imageVideoWhite)
        item3.tabBarItem = icon3
        icon4 = UITabBarItem(title: StringUtil.Anexo, image: ImageUtil.imageVideoBlack, selectedImage: ImageUtil.imageVideoWhite)
        item4.tabBarItem = icon4
        
        var menuButton = UIBarButtonItem()
        
        if self.revealViewController() != nil {
            
            menuButton = UIBarButtonItem(image: ImageUtil.imageMenuButton, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        let back = UIBarButtonItem(image: ImageUtil.imageBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DoubtsResponseTabBarViewController.back))
        self.navigationItem.setLeftBarButtonItems([menuButton, back], animated: true)
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    init() {
        super.init(nibName: StringUtil.doubtsResponseTabBarViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
