//
//  RecoverPasswordViewController.swift
//  Mirage
//
//  Created by Siena Idea on 22/02/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}
