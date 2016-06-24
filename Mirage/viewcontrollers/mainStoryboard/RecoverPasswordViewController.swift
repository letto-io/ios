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
        emailField.keyboardType = UIKeyboardType.ASCIICapable
        
        let recoverPasswordButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(RecoverPasswordViewController.sendButtonTapped))
        self.navigationItem.setRightBarButtonItem(recoverPasswordButton, animated: true)
    }
    
    func sendButtonTapped() {
        // Compose a query string
        let email = emailField.text!
        
        if (email.isEmpty) {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgEmailRequired), animated: true, completion: nil)
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            StringUtil.jsEmail : email,
        ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let request = Server.postRequestParseJSON(Server.recoverPasswordURL, JSONObject: JSONObject)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                if error != nil {
                    print(error)
                    return
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                        
                            if httpResponse.statusCode == 404 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgEmailNotFound), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 401 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgInvalidEmail), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 200 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgSendEmail), animated: true, completion: nil)
                                })
                            }
                        }
                    print(response)
                }
            }
            task.resume()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        emailField.resignFirstResponder()
    }
    
    //chama função de login através do botão ir do teclado
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        sendButtonTapped()
        return true;
    }
}
