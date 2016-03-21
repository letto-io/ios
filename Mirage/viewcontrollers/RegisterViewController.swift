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
            
            displayMyAlertMessage("Todos os campos são requeridos")
            return
        } else if userPasword != repeatPassword {
            displayMyAlertMessage("Senhas não correspodem")
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: "Mensagem", message: userMessage, preferredStyle:
                UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    

    @IBAction func haveAccountButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }
}
