//
//  PDFViewController.swift
//  Mirage
//
//  Created by Oddin on 27/09/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var name = String()
    var dataPath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = name

        let url = URL(fileURLWithPath: dataPath)
        
        let requestObj = URLRequest(url: url)
        webView.loadRequest(requestObj)
    }
}
