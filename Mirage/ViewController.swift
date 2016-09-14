//
//  ViewController.swift
//  Mirage
//
//  Created by Siena Idea on 22/02/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ViewController: ChildViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var login = Login()
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userField.delegate = self
        userField.keyboardType = UIKeyboardType.asciiCapable
        passwordField.delegate = self
        passwordField.keyboardType = UIKeyboardType.asciiCapable
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

    @IBAction func loginButtonTapped() {
        // Compose a query string
        let email = userField.text!
        let password = passwordField.text!
        
        if (email.isEmpty && password.isEmpty) {
            self.present(DefaultViewController.alertMessage(StringUtil.msgEmailPasswordRequired), animated: true, completion: nil)
            return
        } else if (email.isEmpty) {
            self.present(DefaultViewController.alertMessage(StringUtil.msgEmailRequired), animated: true, completion: nil)
            return
        } else if (password.isEmpty) {
            self.present(DefaultViewController.alertMessage(StringUtil.msgPasswordRequired), animated: true, completion: nil)
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            StringUtil.jsEmail : email as AnyObject,
            StringUtil.jsPassord : password as AnyObject
        ]
        
        if JSONSerialization.isValidJSONObject(JSONObject) {
            let request  = Server.postRequestParseJSON(Server.url + Server.session, JSONObject: JSONObject as AnyObject)

            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    print(error)
                    return
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 401 {
                            DispatchQueue.main.async(execute: {
                                self.present(DefaultViewController.alertMessage(StringUtil.msgEmailPasswordIncorrect), animated: true, completion: nil)
                            })
                        } else if httpResponse.statusCode == 201 {
                            let session =  try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            let person = session.value(forKey: StringUtil.person) as! NSDictionary
                            
                            self.login = Login.iterateJSONArray(session, person: person)
                            Server.token = self.login.token
                            TableViewMenuController.person = Person.parsePersonJSON(person)
                            
                            DispatchQueue.main.async(execute: {
                                self.performSegue(withIdentifier: StringUtil.instructionView, sender: self)
                            })
                        } else {
                            DispatchQueue.main.async(execute: {
                                self.present(DefaultViewController.alertMessage(StringUtil.AllError), animated: true, completion: nil)
                            })
                        }
                    }
            }
        }) 
        task.resume()
    }
    }

    //esconde teclado ao tocar em alguma parte da tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    //chama função de login através do botão ir do teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordField.resignFirstResponder()
        
        if passwordField.becomeFirstResponder() {
            loginButtonTapped()
        }
        return true;
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

