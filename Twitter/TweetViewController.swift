//
//  TweetViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 7/30/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweet: Tweet?
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        
        tweetTableView.estimatedRowHeight = 120
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        tweetTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (0 == section) {
            if nil != tweet?.retweetUser {
                return 1
            }
            else {
                return 0
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("retweetUserCell", forIndexPath: indexPath) as! RetweetUserCell
            
            cell.retweetUserLabel.text = "\(tweet?.retweetUser?.name) retweeted"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetViewCell", forIndexPath: indexPath) as! TweetViewCell
            cell.tweet = tweet
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetCountsCell", forIndexPath: indexPath) as! TweetCountsCell
            cell.retweetCountLabel.text = "\((tweet?.retweetCount)!)"
            cell.favoriteCountLabel.text = "\((tweet?.favoriteCount)!)"
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("tweetActionsCell", forIndexPath: indexPath)
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
