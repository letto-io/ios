//
//  MenuViewController.swift
//  Mirage
//
//  Created by Siena Idea on 02/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index : Int32)
}

class MenuViewController: UIViewController {

        // This is where you set the drawer size (i.e. for 1/3rd use 3.0, for 1/5 use 5.0)
        var drawerSize:CGFloat = 4.0
        var leftViewControllerIdentifier:String = "LeftController"
        var centerViewControllerIdentifier:String = "CenterController"
        var rightViewControllerIdentifier:String = "RightController"
        
        private var _leftViewController:UIViewController?
        var leftViewController:UIViewController {
            get{
                if let vc = _leftViewController {
                    return vc;
                }
                return UIViewController();
            }
        }
        private var _centerViewController:UIViewController?
        var centerViewController:UIViewController {
            get{
                if let vc = _centerViewController {
                    return vc;
                }
                return UIViewController();
            }
        }
        private var _rightViewController:UIViewController?
        var rightViewController:UIViewController {
            get{
                if let vc = _rightViewController {
                    return vc;
                }
                return UIViewController();
            }
        }
        
        static let NVMDrawerOpenLeft = 0
        static let NVMDrawerOpenRight = 1
        var openSide:Int {
            get{
                return _openSide;
            }
        }
        private var _openSide:Int = NVMDrawerOpenLeft
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            
            // Instantiate VC's with storyboard ID's
            _leftViewController = instantiateViewControllers(leftViewControllerIdentifier)
            _centerViewController = instantiateViewControllers(centerViewControllerIdentifier)
            _rightViewController = instantiateViewControllers(rightViewControllerIdentifier)
            
            // Call configDrawers() and pass the drawerSize variable.
            drawDrawers(UIScreen.mainScreen().bounds.size)
            
            self.view.addSubview(leftViewController.view)
            self.view.addSubview(centerViewController.view)
            self.view.addSubview(rightViewController.view)
            
        }
        
        override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
                // This is for beginning of transition
                self.drawDrawers(size)
                }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                    // This is for after transition has completed.
            })
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Drawing View
        
        func drawDrawers(size:CGSize) {
            // Calculate Center View's Size
            let centerWidth = (size.width/drawerSize) * (drawerSize - 1)
            
            // Left Drawer
            leftViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: size.width/drawerSize, height: size.height)
            
            // Center Drawer
            centerViewController.view.frame = CGRect(x: leftViewController.view.frame.width, y: 0.0, width: centerWidth, height: size.height)
            
            // Right Drawer
            rightViewController.view.frame = CGRect(x: centerViewController.view.frame.origin.x + centerViewController.view.frame.size.width, y: 0.0, width: size.width/drawerSize, height: size.height)
            //rightViewController = rc
            
            // Capture the Swipes
            let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipeRightAction:"))
            swipeRight.direction = .Right
            centerViewController.view.addGestureRecognizer(swipeRight)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeftAction:"))
            swipeLeft.direction = .Left
            centerViewController.view.addGestureRecognizer(swipeLeft)
            
            if(openSide == MenuViewController.NVMDrawerOpenLeft){
                openLeftDrawer()
            }
            else{
                openRightDrawer()
            }
        }
        
        // MARK: - Open Drawers
        
        func openLeftDrawer() {
            _openSide = MenuViewController.NVMDrawerOpenLeft
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations:
                { () -> Void in
                    // move views here
                    self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion:
                { finished in
            })
        }
        
        func openRightDrawer() {
            _openSide = MenuViewController.NVMDrawerOpenRight
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations:
                { () -> Void in
                    // move views here
                    self.view.frame = CGRect(x: self.view.bounds.origin.x - self.leftViewController.view.bounds.size.width, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion:
                { finished in
            })
        }
        
        // MARK: - Swipe Handling
        
        func swipeRightAction(rec: UISwipeGestureRecognizer){
            self.openLeftDrawer()
        }
        
        func swipeLeftAction(rec:UISwipeGestureRecognizer){
            self.openRightDrawer()
        }
        
        // MARK: - Helpers
        
        func instantiateViewControllers(storyboardID: String) -> UIViewController {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(storyboardID)") as? UIViewController{
                return viewController;
            }
            
            return UIViewController();
        }
}