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

class CreateQuestionViewController: UIViewController {

    @IBOutlet weak var anonymousButton: UIButton!
    @IBOutlet weak var questionTextView: UITextView!
    var instruction = Instruction()
    var presentation = Presentation()
    var isChecked = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = StringUtil.newQuestionTitle
        
        let saveDoubtButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateQuestionViewController.saveNewDoubt))
        self.navigationItem.setRightBarButton(saveDoubtButton, animated: true)
        self.anonymousButton.setImage(ImageUtil.imageCheckBoxButtonWhite, for: UIControlState())
        self.anonymousButton.tintColor = UIColor.gray
    }
    
    func saveNewDoubt() {
        // Compose a query string
        let text = questionTextView.text!
        let anonymous = isChecked
        
        if (text.isEmpty) {
            self.present(DefaultViewController.alertMessage(StringUtil.msgQuestionTextRequired), animated: true, completion: nil)
            return
        } else {
            alertMessageSaveNewDoubt(StringUtil.msgNewQuestionConfirm, text: text, anonymous: anonymous)
        }
    }
    
    func alertMessageSaveNewDoubt(_ userMessage: String, text: String, anonymous: Bool) {
        let myAlert = UIAlertController(title: text, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .destructive) { action -> Void in
            let JSONObject: [String : AnyObject] = [
                StringUtil.jsText : text as AnyObject,
                StringUtil.jsAnonymous : anonymous as AnyObject
            ]
            
            if JSONSerialization.isValidJSONObject(JSONObject) {
                let request = Server.postRequestParseJSONSendToken(Server.url + Server.presentations + "\(self.presentation.id)" + Server.questions, JSONObject: JSONObject as AnyObject)
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                    if error != nil {
                        print(error)
                        return
                    } else {
                        if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                            HTTPCookieStorage.shared.setCookies(cookies, for: response!.url!, mainDocumentURL: nil)
                            
                            if httpResponse.statusCode == 404 {
                                DispatchQueue.main.async(execute: {
                                    self.present(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 401 {
                                DispatchQueue.main.async(execute: {
                                    self.present(DefaultViewController.alertMessage(StringUtil.msgErrorRequest), animated: true, completion: nil)
                                })
                            } else if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async(execute: {
                                    self.navigationController!.popViewController(animated: true)
                                })
                            }
                        }
                    }
                }) 
                task.resume()
            }
        }
        
        let editAction: UIAlertAction = UIAlertAction(title: StringUtil.edit, style: .destructive, handler: nil)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .cancel) { action -> Void in
            self.navigationController!.popViewController(animated: true)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        myAlert.addAction(editAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
//    func alertMessageNewDoubt(userMessage: String, t: String) {
//        let myAlert = UIAlertController(title: t, message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let okAction = UIAlertAction(title: StringUtil.newDoubtTitle, style: UIAlertActionStyle.Default) { action -> Void in
//            self.doubtTextField.text = ""
//        }
//        
//        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .Cancel) { action -> Void in
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//        
//        myAlert.addAction(okAction)
//        myAlert.addAction(cancelAction)
//        
//        self.presentViewController(myAlert, animated: true, completion: nil)
//    }

    @IBAction func anonymousButtonPressed() {
        // Images
        let checkedImage = ImageUtil.imageCheckBoxMarkedButtonWhite
        let uncheckedImage = ImageUtil.imageCheckBoxButtonWhite
        
        if isChecked == true {
            isChecked = false
            self.anonymousButton.tintColor = UIColor.gray
        } else {
            isChecked = true
            self.anonymousButton.tintColor = ColorUtil.orangeColor
        }
        
        if isChecked == true {
            self.anonymousButton.setImage(checkedImage, for: UIControlState())
        } else {
            self.anonymousButton.setImage(uncheckedImage, for: UIControlState())
        }
    }
    
    var delegate:AddNewDoubtDelegate?
    init(delegate:AddNewDoubtDelegate) {
        self.delegate = delegate
        super.init(nibName: "CreateQuestionViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        questionTextView.resignFirstResponder()
    }
}
