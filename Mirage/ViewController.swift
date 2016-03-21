//
//  ViewController.swift
//  Mirage
//
//  Created by Siena Idea on 22/02/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func loginButtonTapped() {
        
        // Compose a query string
        let email = userField.text
        let password = passwordField.text
        
        if (email == nil || password == nil) {
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            "email" : email!,
            "password" : password!,
        ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            let url = Server.loginURL
            
            let _: NSError?
            
            request.URL = NSURL(string: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options:  NSJSONWritingOptions(rawValue:0))
            
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                    data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    } else {
                        if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                            let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                            for cookie in cookies {
                                var cookieProperties = [String: AnyObject]()
                                cookieProperties[NSHTTPCookieName] = cookie.name
                                cookieProperties[NSHTTPCookieValue] = cookie.value
                                cookieProperties[NSHTTPCookieDomain] = cookie.domain
                                cookieProperties[NSHTTPCookiePath] = cookie.path
                                cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
                                cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
                                
                                print("name: \(cookie.name) value: \(cookie.value)")
                                print("name: \(cookie.domain) value: \(cookie.path)")
                                
                                if httpResponse.statusCode == 404 {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
                                        self.displayMyAlertMessage("Email não cadastrado")
                                        
                                    })
                                }
                                
                                if httpResponse.statusCode == 401 {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
                                        self.displayMyAlertMessage("Senha incorreta")
                                        
                                    })
                                }
                                
                                if httpResponse.statusCode == 200 {
                                    let newCookie = NSHTTPCookie(properties: cookieProperties)
                                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie!)
                                    
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                
                            }
                        }
                        print(response)
                    }
                }
                task.resume()
        }
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: "Mensagem", message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
    
}

