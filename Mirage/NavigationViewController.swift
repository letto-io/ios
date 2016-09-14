//
//  NavigationViewController.swift
//  Mirage
//
//  Created by Oddin on 07/09/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

     override var shouldAutorotate : Bool {
        if visibleViewController is ViewController {
            return false   // rotation
        } else {
            return true  // no rotation
        }
    }
    
     override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations)!
    }

}

extension UIAlertController {
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    open override var shouldAutorotate : Bool {
        return false
    }
}
