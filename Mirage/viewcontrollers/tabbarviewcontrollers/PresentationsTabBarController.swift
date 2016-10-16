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
    var teacherMenuButton = UIBarButtonItem()
    var studentMenuButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = instruction.lecture.name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        let item1 = openPresentation()
        let item2  = closedPresentation()
        
        let icon1 = UITabBarItem(title: StringUtil.open, image: ImageUtil.imageOpenBlack , selectedImage: ImageUtil.imageOpenWhite)
        item1.tabBarItem = icon1
        let icon2 = UITabBarItem(title: StringUtil.closed, image: ImageUtil.imageClosedBlack, selectedImage: ImageUtil.imageClosedWhite)
        item2.tabBarItem = icon2
        
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    
        //verifica se é um perfil de professor para criar novas apresentações
        if instruction.profile == 1 {
            teacherMenuButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(PresentationsTabBarController.menuTeacher))
            teacherMenuButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButton(teacherMenuButton, animated: true)
        } else if instruction.profile == 0 {
            studentMenuButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(PresentationsTabBarController.menuStudent))
            studentMenuButton.tintColor = ColorUtil.orangeColor
            
            self.navigationItem.setRightBarButton(studentMenuButton, animated: true)
        }
    }
    
    
    func openPresentation() -> OpenPresentationViewController {
        let item1 = OpenPresentationViewController()
        item1.instruction = instruction
        
        return item1
    }
    
    func closedPresentation() -> ClosedPresentationViewController {
        let item2  = ClosedPresentationViewController()
        item2.instruction = instruction
        
        return item2
    }
    
    func menuTeacher() {
        let myAlert = UIAlertController(title: instruction.lecture.name, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let createPresentationAction: UIAlertAction = UIAlertAction(title: StringUtil.newPresentationTitle, style: .default) { action -> Void in
            let newPresentation = CreatePresentationViewController(delegate: self)
            newPresentation.instruction = self.instruction
            
            self.navigationController?.pushViewController(newPresentation, animated: true)
        }
        
        let downloadMaterialAction: UIAlertAction = UIAlertAction(title: StringUtil.download, style: .default) { action -> Void in
            let material = InstructionMaterialViewController()
            material.instruction = self.instruction
            
            self.navigationController?.pushViewController(material, animated: true)
        }
        
        let uploadMaterialAction: UIAlertAction = UIAlertAction(title: StringUtil.upload, style: .default) { action -> Void in
            
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .cancel) { action -> Void in
            
        }
        
        myAlert.addAction(createPresentationAction)
        myAlert.addAction(downloadMaterialAction)
        myAlert.addAction(uploadMaterialAction)
        myAlert.addAction(cancelAction)
        
        if let popoverController = myAlert.popoverPresentationController {
            popoverController.barButtonItem = teacherMenuButton
        }
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func menuStudent() {
        let myAlert = UIAlertController(title: instruction.lecture.name, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let downloadMaterialAction: UIAlertAction = UIAlertAction(title: StringUtil.download, style: .default) { action -> Void in
            let material = InstructionMaterialViewController()
            
            material.instruction = self.instruction
            
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
        super.init(nibName: StringUtil.presentationsTabBarController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
