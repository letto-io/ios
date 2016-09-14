//
//  DefaultViewController.swift
//  Mirage
//
//  Created by Oddin on 17/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DefaultViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        addChildView("InstructionScreenID", titleOfChildren: "Disciplinas", iconName: "book-multiple-black")
        
        //Show the first childScreen
        showFirstChild()
    }
    
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    //funções para uso em qualquer Controller
    
    static func refreshTableView(_ tableView: UITableView, cellNibName: String, view: UIView) -> UITableView {
        let nib = UINib(nibName: cellNibName , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: StringUtil.cell)
        view.addSubview(tableView)
        return tableView
    }
    
    static func refreshControl(_ refreshControl: UIRefreshControl, tableView: UITableView) -> UIRefreshControl {
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        return refreshControl
    }
    
    //exibe mensagens de alerta
    static func alertMessage(_ userMessage: String) -> UIAlertController {
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: StringUtil.ok, style: UIAlertActionStyle.destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        return myAlert
    }
    
    //exibe mensagens de alerta
    static func alertMessagePushViewController(_ userMessage: String, navigationController: UINavigationController) -> UIAlertController {
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)

        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.ok, style: .destructive) { action -> Void in
            navigationController.popViewController(animated: true)
        }
        
        myAlert.addAction(okAction)
        
        return myAlert
    }
}
