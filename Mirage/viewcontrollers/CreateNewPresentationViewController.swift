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

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameTextField: UITextField!
    
    var id = OpenPresentationsViewController().id
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navItem = UINavigationItem(title: "Nova Apresentação");

        let newItemButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(CreateNewPresentationViewController.cancel))
        
        let saveItemButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: #selector(CreateNewPresentationViewController.saveNewPresentation))
        
        navItem.leftBarButtonItem = newItemButton
        navItem.rightBarButtonItem = saveItemButton
        navigationBar.setItems([navItem], animated: false)
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveNewPresentation() {
        
        // Compose a query string
        let subject = nameTextField.text
        
        if (subject!.isEmpty) {
            
            displayMyAlertMessage("Campo obrigatório")
            return
        }
        
        let JSONObject: [String : AnyObject] = [
            "subject" : subject!
            ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            let url = Server.presentationURL+"\(id)" + Server.presentation
            
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
                        
                        if httpResponse.statusCode == 404 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.displayMyAlertMessage("Erro 404")
                                
                            })
                        }
                        
                        if httpResponse.statusCode == 401 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.displayMyAlertMessage("Erro 401")
                                
                            })
                        }

                        
                        if httpResponse.statusCode == 200 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
                        }
                    }
                    print(response)
                }
            }
            task.resume()
        }
    }

    var delegate:AddNewPresentationDelegate?
    init(delegate:AddNewPresentationDelegate) {
        self.delegate = delegate
        super.init(nibName: "CreateNewPresentationViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title: "Mensagem", message: userMessage, preferredStyle:
            UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTextField.resignFirstResponder()
        
        
    }

}
