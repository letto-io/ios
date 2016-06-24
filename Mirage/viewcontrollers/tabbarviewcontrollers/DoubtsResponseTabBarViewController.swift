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
        self.navigationItem.title = doubt.text

        let item1  = TextDoubtReponseViewController()
        item1.discipline = discipline
        item1.presentation = presentation
        item1.doubt = doubt
        item1.getDoubtResponse()
        
        let item2 = AudioDoubtResponseViewController()
        item2.discipline = discipline
        item2.presentation = presentation
        item2.doubt = doubt
        item2.getDoubtResponse()
        
        let item3 = VideoDoubtResponseViewController()
        item3.discipline = discipline
        item3.presentation = presentation
        item3.doubt = doubt
        item3.getDoubtResponse()
        
        let item4 = AttachmentDoubtResponseViewController()
        item4.discipline = discipline
        item4.presentation = presentation
        item4.doubt = doubt
        item4.getDoubtResponse()
        
        icon1 = UITabBarItem(title: StringUtil.Texto, image: ImageUtil.imageTextBlack, selectedImage: ImageUtil.imageTextWhite)
        item1.tabBarItem = icon1
        icon2 = UITabBarItem(title: StringUtil.Audio, image: ImageUtil.imageAudioBlack, selectedImage: ImageUtil.imageAudioWhite)
        item2.tabBarItem = icon2
        icon3 = UITabBarItem(title: StringUtil.Video, image: ImageUtil.imageVideoBlack, selectedImage: ImageUtil.imageVideoWhite)
        item3.tabBarItem = icon3
        icon4 = UITabBarItem(title: StringUtil.Anexo, image: ImageUtil.imageVideoBlack, selectedImage: ImageUtil.imageVideoWhite)
        item4.tabBarItem = icon4
        
        let controllers = [item1, item2, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    init() {
        super.init(nibName: StringUtil.doubtsResponseTabBarViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
