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
        
        var menuButton = UIBarButtonItem()
        
        if self.revealViewController() != nil {
            
            menuButton = UIBarButtonItem(image: ImageUtil.imageMenuButton, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        let back = UIBarButtonItem(image: ImageUtil.imageBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateNewDoubtViewController.back))
        self.navigationItem.setLeftBarButtonItems([menuButton, back], animated: true)

        let saveDoubtButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateNewDoubtViewController.saveNewDoubt))
        
        self.navigationItem.setRightBarButtonItem(saveDoubtButton, animated: true)
        
        self.anonymousButton.setImage(ImageUtil.imageCheckBoxButtonWhite, forState: .Normal)
        self.anonymousButton.tintColor = UIColor.grayColor()
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveNewDoubt() {
        
        // Compose a query string
        let text = doubtTextField.text
        let anonymous = isChecked.boolValue
        
        
        if (text!.isEmpty) {
            displayMyAlertMessage(StringUtil.msgDoubtTextRequired)
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            StringUtil.jsText : text!,
            StringUtil.jsAnonymous : anonymous
        ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            let url = Server.presentationURL+"\(discipline.id)" + Server.presentaion_bar + "\(presentation.id)" + Server.doubt
            
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
                                self.displayMyAlertMessage(StringUtil.error404)
                                
                            })
                        }
                        
                        if httpResponse.statusCode == 401 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.displayMyAlertMessage(StringUtil.error401)
                                
                            })
                        }
                        
                        
                        if httpResponse.statusCode == 200 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                    }
                    print(response)
                }
            }
            task.resume()
        }

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
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: StringUtil.message, message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: StringUtil.ok, style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        doubtTextField.resignFirstResponder()
    }

}
