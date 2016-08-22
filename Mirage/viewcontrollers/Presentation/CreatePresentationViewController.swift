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

class CreatePresentationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    var instruction = Instruction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = StringUtil.newPresentationTitle
    
        let saveItemButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreatePresentationViewController.saveNewPresentation))
        self.navigationItem.setRightBarButtonItem(saveItemButton, animated: true)
    }
    
    func saveNewPresentation() {
        // Compose a query string
        let subject = nameTextField.text
        
        if (subject!.isEmpty) {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgSubjectRequired), animated: true, completion: nil)
            return
        } else {
            alertMessageSaveNewPresentation(StringUtil.msgNewPresentationConfirm, subject: subject!)
        }
    }

    var delegate:AddNewPresentationDelegate?
    init(delegate:AddNewPresentationDelegate) {
        self.delegate = delegate
        super.init(nibName: StringUtil.CreatePresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func alertMessageSaveNewPresentation(userMessage: String, subject: String) {
        let myAlert = UIAlertController(title: subject, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .Destructive) { action -> Void in
            let JSONObject: [String : AnyObject] = [
                StringUtil.subject : subject
            ]
            
            if NSJSONSerialization.isValidJSONObject(JSONObject) {
                let request = Server.postRequestParseJSONSendToken(Server.url + Server.instructions + "\(self.instruction.id)" + Server.presentations, JSONObject: JSONObject)

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
                                    self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 401 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 200 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.alertMessageNewPresentation(StringUtil.msgNewPresentationSuccess, t: subject)
                                })
                            }
                        }
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
    
    func alertMessageNewPresentation(userMessage: String, t: String) {
        let myAlert = UIAlertController(title: t, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
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
