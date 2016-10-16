//
//  RecoverPasswordViewController.swift
//  Mirage
//
//  Created by Siena Idea on 22/02/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        emailField.delegate = self
        emailField.keyboardType = UIKeyboardType.asciiCapable
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        let saveDoubtButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(RecoverPasswordViewController.sendButtonTapped))
        self.navigationItem.setRightBarButton(saveDoubtButton, animated: true)
    }
    
    func sendButtonTapped() {
        // Compose a query string
        let email = emailField.text!
        
        if (email.isEmpty) {
            self.present(DefaultViewController.alertMessage(StringUtil.msgEmailRequired), animated: true, completion: nil)
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            StringUtil.jsEmail : email as AnyObject
        ]
        
        if JSONSerialization.isValidJSONObject(JSONObject) {
            let request = Server.postRequestParseJSON(Server.url + Server.recoverpassword, JSONObject as AnyObject)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    print(error)
                    return
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 404 {
                                DispatchQueue.main.async(execute: {
                                    self.present(DefaultViewController.alertMessage(StringUtil.msgEmailNotFound), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 401 {
                                DispatchQueue.main.async(execute: {
                                    self.present(DefaultViewController.alertMessage(StringUtil.msgInvalidEmail), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async(execute: {
                                    self.present(DefaultViewController.alertMessagePushViewController(StringUtil.msgSendEmail, navigationController: self.navigationController!), animated: true, completion: nil)
                                })
                            }
                        }
                }
            }) 
            task.resume()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.resignFirstResponder()
    }
    
    //chama função de login através do botão ir do teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        sendButtonTapped()
        return true;
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

