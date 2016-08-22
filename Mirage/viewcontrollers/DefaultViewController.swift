//
//  DefaultViewController.swift
//  Mirage
//
//  Created by Oddin on 17/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController {
    
   static func refreshTableView(tableView: UITableView, cellNibName: String, view: UIView) -> UITableView {
        let nib = UINib(nibName: cellNibName , bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: StringUtil.cell)
        view.addSubview(tableView)
        return tableView
    }
    
    static func refreshControl(refreshControl: UIRefreshControl, tableView: UITableView) -> UIRefreshControl {
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        return refreshControl
    }
    
    //exibe mensagens de alerta
    static func alertMessage(userMessage: String) -> UIAlertController {
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: StringUtil.ok, style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        return myAlert
    }
    
//    //exibe mensagens de alerta
//    static func alertMessageTableIsEmpty(userMessage: String, navigationController: UINavigationController) -> UIAlertController {
//        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let backAction = UIAlertAction(title: StringUtil.back, style: .Destructive) { action -> Void in
//            navigationController.popViewControllerAnimated(true)
//        }
//        
//        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.ok, style: .Default) { action -> Void in
//            print(StringUtil.ok)
//        }
//        
//        myAlert.addAction(backAction)
//        myAlert.addAction(okAction)
//        
//        return myAlert
//    }
}
