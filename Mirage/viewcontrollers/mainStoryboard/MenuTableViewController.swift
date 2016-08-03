//
//  MenuTableViewController.swift
//  Mirage
//
//  Created by Siena Idea on 26/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var exitLabel: UILabel!
    @IBOutlet weak var imageViewExit: UIImageView!
    @IBOutlet weak var optionsLabel: UILabel!
    
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = "User Name"
        loginLabel.text = "email@email.com"
        optionsLabel.text = "Opções"
        exitLabel.text = "Sair"
        
        imageViewExit.image = ImageUtil.imageExitButton
        imageViewExit.tintColor = UIColor.lightGrayColor()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    @IBAction func exitButton(sender: AnyObject) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var cookies = cookieStorage.cookies! as [NSHTTPCookie]
        cookies.removeAll(keepCapacity: true)
    }
}
