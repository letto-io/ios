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
        
        let back = UIBarButtonItem(image: ImageUtil.imageBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(RecoverPasswordViewController.back))
        self.navigationItem.setLeftBarButtonItem(back, animated: true)
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func sendButtonTapped() {
        
        // Compose a query string
        let email = emailField.text
        
        if (email!.isEmpty) {
            
            displayMyAlertMessage(StringUtil.msgEmailRequired)
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            StringUtil.jsEmail : email!,
        ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            let url = Server.recoverPasswordURL
            
            let _: NSError?
            
            request.URL = NSURL(string: url)
            request.HTTPMethod = StringUtil.httpPOST
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
            request.setValue(StringUtil.httpApplication, forHTTPHeaderField: StringUtil.httpHeader)
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options:  NSJSONWritingOptions(rawValue:0))
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil {
                    print(error)
                    return
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                        
                        
                            if httpResponse.statusCode == 404 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage(StringUtil.msgEmailNotFound)
                                    
                                })
                            }
                            
                            if httpResponse.statusCode == 401 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage(StringUtil.msgInvalidEmail)
                                    
                                })
                            }
                            
                            if httpResponse.statusCode == 200 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage(StringUtil.msgSendEmail)
                                    
                                })
                            }
                        
                        }
                    
                    print(response)
                }
            }
            task.resume()
        }
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: StringUtil.ok, style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
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
