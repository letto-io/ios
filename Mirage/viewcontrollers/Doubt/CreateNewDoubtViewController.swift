//
//  CreateNewDoubtViewController.swift
//  Mirage
//
//  Created by Siena Idea on 12/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

protocol AddNewDoubtDelegate {
    
}

class CreateNewDoubtViewController: UIViewController {

    @IBOutlet weak var doubtTextField: UITextField!
    @IBOutlet weak var anonymousButton: UIButton!
    var discipline = Discipline()
    var presentation = Presentation()
    var isChecked = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = StringUtil.newDoubtTitle
        
        let saveDoubtButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateNewDoubtViewController.saveNewDoubt))
        self.navigationItem.setRightBarButtonItem(saveDoubtButton, animated: true)
        self.anonymousButton.setImage(ImageUtil.imageCheckBoxButtonWhite, forState: .Normal)
        self.anonymousButton.tintColor = UIColor.grayColor()
    }
    
    func saveNewDoubt() {
        // Compose a query string
        let text = doubtTextField.text!
        let anonymous = isChecked.boolValue
        
        if (text.isEmpty) {
            self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgDoubtTextRequired), animated: true, completion: nil)
            return
        } else {
            alertMessageSaveNewDoubt(StringUtil.msgNewDoubtConfirm, text: text, anonymous: anonymous)
        }
    }
    
    func alertMessageSaveNewDoubt(userMessage: String, text: String, anonymous: Bool) {
        let myAlert = UIAlertController(title: text, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .Destructive) { action -> Void in
            let JSONObject: [String : AnyObject] = [
                StringUtil.jsText : text,
                StringUtil.jsAnonymous : anonymous
            ]
            
            if NSJSONSerialization.isValidJSONObject(JSONObject) {
                let request = Server.postRequestParseJSON(Server.presentationURL+"\(self.discipline.id)" + Server.presentaion_bar + "\(self.presentation.id)" + Server.doubt, JSONObject: JSONObject)
                
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
                                    self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 401 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.presentViewController(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 200 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.alertMessageNewDoubt(StringUtil.msgNewDoubtSuccess, t: text)
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
    
    func alertMessageNewDoubt(userMessage: String, t: String) {
        let myAlert = UIAlertController(title: t, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: StringUtil.newDoubtTitle, style: UIAlertActionStyle.Default) { action -> Void in
            self.doubtTextField.text = ""
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .Cancel) { action -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    @IBAction func anonymousButtonPressed() {
        // Images
        let checkedImage = ImageUtil.imageCheckBoxMarkedButtonWhite
        let uncheckedImage = ImageUtil.imageCheckBoxButtonWhite
        
        if isChecked == true {
            isChecked = false
            self.anonymousButton.tintColor = UIColor.grayColor()
        } else {
            isChecked = true
            self.anonymousButton.tintColor = ColorUtil.orangeColor
        }
        
        if isChecked == true {
            self.anonymousButton.setImage(checkedImage, forState: .Normal)
        } else {
            self.anonymousButton.setImage(uncheckedImage, forState: .Normal)
        }
    }
    
    var delegate:AddNewDoubtDelegate?
    init(delegate:AddNewDoubtDelegate) {
        self.delegate = delegate
        super.init(nibName: StringUtil.createNewDoubtViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        doubtTextField.resignFirstResponder()
    }
}
