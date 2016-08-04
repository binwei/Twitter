//
//  LoginViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 7/28/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLoginButton(sender: UIButton) {
        TwitterClient.sharedInstance.login({
            // segue into the next controller
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error) in
            
            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .Alert)
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let hamburgerController = segue.destinationViewController as! HamburgerViewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("menuNavigationController") as! UINavigationController
        let menuController = menuNavigationController.topViewController as! MenuViewController
        menuController.initializeContentControllers()
        
        menuController.hamburgerController = hamburgerController
        hamburgerController.menuController = menuNavigationController
        hamburgerController.setInitialContentController()
    }
}
