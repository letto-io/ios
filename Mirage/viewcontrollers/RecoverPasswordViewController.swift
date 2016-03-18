//
//  RecoverPasswordViewController.swift
//  Mirage
//
//  Created by Siena Idea on 22/02/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    
    
    @IBAction func sendButtonTapped() {
        
        // Compose a query string
        let email = emailField.text
        
        if (email == nil) {
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            "email" : email!,
        ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            let url = Server.recoverPasswordURL
            
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
                        
//                        for cookie in cookies {
//                            var cookieProperties = [String: AnyObject]()
//                            cookieProperties[NSHTTPCookieName] = cookie.name
//                            cookieProperties[NSHTTPCookieValue] = cookie.value
//                            cookieProperties[NSHTTPCookieDomain] = cookie.domain
//                            cookieProperties[NSHTTPCookiePath] = cookie.path
//                            cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
//                            cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
//                            
//                            print("name: \(cookie.name) value: \(cookie.value)")
//                            print("name: \(cookie.domain) value: \(cookie.path)")
                        
                            if httpResponse.statusCode == 404 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage("Email not found")
                                    
                                })
                            }
                            
                            if httpResponse.statusCode == 401 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage("Invalid email")
                                    
                                })
                            }
                            
                            if httpResponse.statusCode == 200 {
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage("Sucess")
                                    
                                })
                            }
                            
                        }
                    
                    print(response)
                }
            }
            task.resume()
        }
    }
    
    
    @IBAction func barButtonItemTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func displayMyAlertMessage(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Message", message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        emailField.resignFirstResponder()
    }
    
}
