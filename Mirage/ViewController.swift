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
            let request  = Server.postRequestParseJSON(Server.loginURL, JSONObject: JSONObject)
    
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                if error != nil {
                    print(error)
                    return
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                        
                        if httpResponse.statusCode == 401 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgEmailPasswordIncorrect), animated: true, completion: nil)
                            })
                        } else if httpResponse.statusCode == 200 {
                            for cookie in cookies {
                                var cookieProperties = [String: AnyObject]()
                                cookieProperties[NSHTTPCookieName] = cookie.name
                                cookieProperties[NSHTTPCookieValue] = cookie.value
                                cookieProperties[NSHTTPCookieDomain] = cookie.domain
                                cookieProperties[NSHTTPCookiePath] = cookie.path
                                cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
                                cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
                                
                                let newCookie = NSHTTPCookie(properties: cookieProperties)
                                NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie!)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier(StringUtil.disciplineView, sender: self)
                                })
                            }
                        }
                    print(response)
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

