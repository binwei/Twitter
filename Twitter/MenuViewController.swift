//
//  MenuViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 8/4/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var hamburgerController: HamburgerViewController!
    
    var contentControllers = [UINavigationController]()
    
    var defaultContentController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.estimatedRowHeight = 100
        menuTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initializeContentControllers() {
        let storyboard = navigationController?.storyboard
        let tweetsNavigationController = storyboard?.instantiateViewControllerWithIdentifier("tweetsNavigationController") as! UINavigationController
        let profileNavigationController = storyboard?.instantiateViewControllerWithIdentifier("profileNavigationController") as! UINavigationController
        
        contentControllers.append(profileNavigationController)
        contentControllers.append(tweetsNavigationController)
        
        defaultContentController = tweetsNavigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let navigationController = contentControllers[indexPath.row]
        
        if (indexPath.row == 0) {
            let profileController = navigationController.topViewController as! ProfileViewController
            profileController.user = User.currentUser
        }
        hamburgerController.contentController = navigationController
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
        
        if (indexPath.row == 0) {
            cell.textLabel?.text = "Profile"
            cell.detailTextLabel?.text = "Show Profile for currently logged in user"
        }
        else {
            cell.textLabel?.text = "Home Timeline"
        }
        
        return cell
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
