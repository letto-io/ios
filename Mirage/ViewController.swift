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

    @IBAction func login() {
        
        let session = NSURLSession.sharedSession()
        let myUrl = NSURL(string: "http://rest-server-mirage.herokuapp.com/controller/login")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        // Compose a query string
        let email = userField.text
        let password = passwordField.text
        
        if (email == nil || password == nil) {
            return
        }
        
        
        let postString = "email=\(email)&password=\(password)";
        
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            //Let’s convert response sent from a server side script to a NSDictionary object:
            
            var err: NSError?
            
            do {
                let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if (err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                
                if let parseJSON = myJSON {
                    // Now we can access value of First Name by its key
                    let email = parseJSON["email"] as? String
                    let password = parseJSON["password"] as? String
                    print("firstNameValue: \(email)")
                }
            } catch {
                print(error)
            }
            
            
            
        }
        
        task.resume()
        
            }

    @IBAction func recoverPassword() {
        
        
    }
}

