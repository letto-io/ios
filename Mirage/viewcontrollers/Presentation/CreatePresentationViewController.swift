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
    
        let saveItemButton = UIBarButtonItem(image: ImageUtil.imageSaveButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreatePresentationViewController.saveNewPresentation))
        self.navigationItem.setRightBarButton(saveItemButton, animated: true)
    }
    
    func saveNewPresentation() {
        // Compose a query string
        let subject = nameTextField.text
        
        if (subject!.isEmpty) {
            self.present(DefaultViewController.alertMessage(StringUtil.msgSubjectRequired), animated: true, completion: nil)
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
    
    func alertMessageSaveNewPresentation(_ userMessage: String, subject: String) {
        let myAlert = UIAlertController(title: subject, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: StringUtil.confirm, style: .destructive) { action -> Void in
            let JSONObject: [String : AnyObject] = [
                StringUtil.subject : subject as AnyObject
            ]
            
            if JSONSerialization.isValidJSONObject(JSONObject) {
                let request = Server.postRequestParseJSONSendToken(Server.url + Server.instructions + "\(self.instruction.id)" + Server.presentations, JSONObject: JSONObject as AnyObject)

                let task = URLSession.shared.dataTask(with: request, completionHandler: {
                    data, response, error in
                    
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
                                    self.alertMessageNewPresentation(StringUtil.msgNewPresentationSuccess, t: subject)
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
            self.navigationController?.popViewController(animated: true)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        myAlert.addAction(editAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func alertMessageNewPresentation(_ userMessage: String, t: String) {
        let myAlert = UIAlertController(title: t, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: StringUtil.newPresentationTitle, style: UIAlertActionStyle.default) { action -> Void in
            self.nameTextField.text = ""
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: StringUtil.cancel, style: .cancel) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
    }
}
