//
//  LoggedViewController.swift
//  Mirage
//
//  Created by Siena Idea on 02/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class LoggedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
                
            if cookies.isEmpty {
                self.performSegueWithIdentifier("loginView", sender: self)
            
        }
    }

    @IBAction func signoutButtonTapped(sender: AnyObject) {
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookies! as [NSHTTPCookie]
        print("Cookies.count: \(cookies.count)")
        for cookie in cookies {
            print("name: \(cookie.name) value: \(cookie.value)")
            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
        }
        
        self.performSegueWithIdentifier("loginView", sender: self)
        
    }
}
