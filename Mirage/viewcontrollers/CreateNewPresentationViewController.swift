//
//  CreateNewPresentationViewController.swift
//  Mirage
//
//  Created by Siena Idea on 11/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

protocol AddNewPresentationDelegate {

}

class CreateNewPresentationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var id = OpenPresentationViewController().id
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = StringUtil.newPresentationTitle
        
        var menuButton = UIBarButtonItem()
        
        if self.revealViewController() != nil {
            
            menuButton = UIBarButtonItem(image: ImageUtil.imageMenuButton, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        let back = UIBarButtonItem(image: ImageUtil.imageBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateNewPresentationViewController.back))
        self.navigationItem.setLeftBarButtonItems([menuButton, back], animated: true)

        
        let saveItemButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateNewPresentationViewController.saveNewPresentation))
        
        self.navigationItem.setRightBarButtonItem(saveItemButton, animated: true)
        
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveNewPresentation() {
        
        // Compose a query string
        let subject = nameTextField.text
        
        if (subject!.isEmpty) {
            
            displayMyAlertMessage(StringUtil.msgSubjectRequired)
            return
        } else {
            displayMyAlertMessage(StringUtil.msgNewPresentationConfirm, subject: subject!)
        }
    }

    var delegate:AddNewPresentationDelegate?
    init(delegate:AddNewPresentationDelegate) {
        self.delegate = delegate
        super.init(nibName: StringUtil.createNewPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func displayMyAlertMessage(userMessage: String, subject: String) {
        
        let myAlert = UIAlertController(title: subject, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .Destructive) { action -> Void in
            
            let JSONObject: [String : AnyObject] = [
                StringUtil.subject : subject
            ]
            
            if NSJSONSerialization.isValidJSONObject(JSONObject) {
                let request: NSMutableURLRequest = NSMutableURLRequest()
                let url = Server.presentationURL+"\(self.id)" + Server.presentaion
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
                                    self.displayMyAlertMessage(StringUtil.msgErrorRequest)
                                    
                                })
                            }
                            
                            if httpResponse.statusCode == 401 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage(StringUtil.msgErrorRequest)
                                    
                                })
                            }
                            
                            
                            if httpResponse.statusCode == 200 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.displayMyAlertMessage(StringUtil.msgNewPresentationSuccess, t: subject)
                                })
                            }
                        }
                        print(response)
                    }
                }
                task.resume()
            }

        }
        let editAction: UIAlertAction = UIAlertAction(title: StringUtil.edit, style: .Destructive, handler: nil)
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .Cancel) { action -> Void in
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        myAlert.addAction(editAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: StringUtil.ok, style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func displayMyAlertMessage(userMessage: String, t: String) {
        
        let myAlert = UIAlertController(title: t, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: StringUtil.newPresentationTitle, style: UIAlertActionStyle.Default) { action -> Void in
            
            self.nameTextField.text = ""
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .Cancel) { action -> Void in
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTextField.resignFirstResponder()
        
        
    }

}
