//
//  RegisterViewController.swift
//  Mirage
//
//  Created by Siena Idea on 24/02/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text
        let userPasword = userPasswordTextField.text
        let repeatPassword = repeatPasswordTextField.text
        
        if userEmail!.isEmpty || userPasword!.isEmpty || repeatPassword!.isEmpty {
            
            displayMyAlertMessage("All fields are required")
            return
        }
        
        if userPasword != repeatPassword {
            displayMyAlertMessage("Password do not match")
        }
        
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle:
                UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    

}
