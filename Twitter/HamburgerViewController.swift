//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 8/4/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftContentAnchor: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    var menuController: UINavigationController! {
        didSet {
            view.layoutIfNeeded()
            
            menuController.willMoveToParentViewController(self)
            self.menuView.addSubview(menuController.view)
            menuController.didMoveToParentViewController(self)
        }
    }
    
    var contentController: UINavigationController! {
        didSet(oldContentController) {
            view.layoutIfNeeded()
            
            if (nil != oldContentController) {
                oldContentController.willMoveToParentViewController(nil)
                oldContentController.view.removeFromSuperview()
                oldContentController.didMoveToParentViewController(nil)
            }
            
            contentController.willMoveToParentViewController(self)
            self.contentView.addSubview(contentController.view)
            contentController.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(0.3) { 
                self.leftContentAnchor.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setInitialContentController() {
        let viewController = menuController.topViewController as! MenuViewController
        contentController = viewController.defaultContentController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doPanView(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        switch sender.state {
        case .Began:
            originalLeftMargin = leftContentAnchor.constant
        case .Changed:
            leftContentAnchor.constant = originalLeftMargin + translation.x
        case .Ended:
            UIView.animateWithDuration(0.6, animations: {
                if (velocity.x > 0) {
                    self.leftContentAnchor.constant = self.view.frame.size.width - 100
                }
                else {
                    self.leftContentAnchor.constant = 0
                }
                
                self.view.layoutIfNeeded()
            })
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
