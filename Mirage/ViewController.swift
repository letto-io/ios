//
//  ViewController.swift
//  Mirage
//
//  Created by Siena Idea on 22/02/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var login: Login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userField.delegate = self
        userField.keyboardType = UIKeyboardType.ASCIICapable
        passwordField.delegate = self
        passwordField.keyboardType = UIKeyboardType.ASCIICapable
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }

    @IBAction func loginButtonTapped() {
        // Compose a query string
        let email = userField.text!
        let password = passwordField.text!
        
        if (email.isEmpty && password.isEmpty) {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgEmailPasswordRequired), animated: true, completion: nil)
            return
        } else if (email.isEmpty) {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgEmailRequired), animated: true, completion: nil)
            return
        } else if (password.isEmpty) {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgPasswordRequired), animated: true, completion: nil)
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            StringUtil.jsEmail : email,
            StringUtil.jsPassord : password
        ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let request  = Server.postRequestParseJSON(Server.url + Server.session, JSONObject: JSONObject)
    
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                if error != nil {
                    print(error)
                    return
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 401 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgEmailPasswordIncorrect), animated: true, completion: nil)
                            })
                        } else if httpResponse.statusCode == 201 {
                            let loginJSONData =  try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                            self.login = Login.iterateJSONArray(loginJSONData)
                            Server.token = self.login.token
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSegueWithIdentifier(StringUtil.disciplineView, sender: self)
                            })
                        }
                    }
            }
        }
        task.resume()
    }
    }
    
    //esconde teclado ao tocar em alguma parte da tela
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    //chama função de login através do botão ir do teclado
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userField.resignFirstResponder()
        
        if passwordField.becomeFirstResponder() {
            loginButtonTapped()
        }
        return true;
    }
}

