//
//  MenuViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 8/4/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit
import AFNetworking

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
        let mentionsNavigationController = storyboard?.instantiateViewControllerWithIdentifier("mentionsNavigationController") as! UINavigationController
        let favoritesNavigationController = storyboard?.instantiateViewControllerWithIdentifier("favoritesNavigationController") as! UINavigationController
        
        contentControllers.append(profileNavigationController)
        contentControllers.append(tweetsNavigationController)
        contentControllers.append(mentionsNavigationController)
        contentControllers.append(favoritesNavigationController)
        
        defaultContentController = tweetsNavigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentControllers.count + 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row > 0) {
            let controllerIndex = indexPath.row - 1
            let navigationController = contentControllers[controllerIndex]
            if (controllerIndex == 0) {
                let profileController = navigationController.topViewController as! ProfileViewController
                profileController.user = User.currentUser
            }
            
            hamburgerController.contentController = navigationController
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            return tableView.dequeueReusableCellWithIdentifier("currentUserCell", forIndexPath: indexPath) as! CurrentUserCell
        }
        else {
            let controllerIndex = indexPath.row - 1
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
            
            cell.imageView?.contentMode = .ScaleAspectFill
            cell.imageView?.sizeToFit()
            if (controllerIndex == 0) {
                cell.textLabel?.text = "Profile"
                cell.imageView?.image = UIImage(named: "profile")
            }
            else if (controllerIndex == 1){
                cell.textLabel?.text = "Timeline"
                cell.imageView?.image = UIImage(named: "home")
            } else if (controllerIndex == 2){
                cell.textLabel?.text = "Mentions"
                cell.imageView?.image = UIImage(named: "quote")
            } else {
                cell.textLabel?.text = "Favorites"
                cell.imageView?.image = UIImage(named: "favorite")
            }
            return cell
        }
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
