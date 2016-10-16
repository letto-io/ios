//
//  ImageViewController.swift
//  Mirage
//
//  Created by Oddin on 29/09/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imagePAth = String()
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name

        imageView.image =  UIImage(contentsOfFile: imagePAth)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(imageView)
    }
}
