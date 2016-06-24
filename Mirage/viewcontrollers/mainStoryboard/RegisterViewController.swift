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
    }

    @IBAction func registerButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text!
        let userPasword = userPasswordTextField.text!
        let repeatPassword = repeatPasswordTextField.text!
        
        if userEmail.isEmpty || userPasword.isEmpty || repeatPassword.isEmpty {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgAllRequired), animated: true, completion: nil)
            return
        } else if userPasword != repeatPassword {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgPasswordNotMatch), animated: true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }
}
