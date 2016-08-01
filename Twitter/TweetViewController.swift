//
//  TweetViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 7/30/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

protocol TweetViewControllerDelegate: class {
    func tweetViewController(tweetViewController: TweetViewController, didUpdateTweet tweet: Tweet)
}

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCountsCellDelete {
    
    var tweet: Tweet?
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    weak var delegate: TweetViewControllerDelegate?
    
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
        return 3
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
            
            cell.retweetUserLabel.text = "\((tweet?.retweetUser?.name)!) retweeted"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetViewCell", forIndexPath: indexPath) as! TweetViewCell
            cell.tweet = tweet
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetCountsCell", forIndexPath: indexPath) as! TweetCountsCell
            cell.retweetCountLabel.text = "\((tweet?.retweetCount)!)"
            cell.favoriteCountLabel.text = "\((tweet?.favoriteCount)!)"
            
            cell.delegate = self
            return cell
        }
    }
    
    func tweetCountsCell(tweetCountsCell: TweetCountsCell, didTweetAction tweetAction: TweetAction) {
        switch tweetAction {
        case .Retweet:
            TwitterClient.sharedInstance.retweet(tweet!, success: { (retweet:Tweet) in
                self.tweet = retweet
                self.tweetTableView.reloadData()
                
                self.delegate?.tweetViewController(self, didUpdateTweet: retweet)
                }, failure: { (error) in
                    // TBD add alert controller
                    NSLog("retweet of \(self.tweet?.idString) by \((self.tweet!.user?.name)!) failed: \(error.localizedDescription)")
            })
            
        case .Favor:
            TwitterClient.sharedInstance.favor(tweet!, success: { (updatedTweet: Tweet) in
                self.tweet?.favoriteCount = updatedTweet.favoriteCount
                self.tweetTableView.reloadData()
                
                self.delegate?.tweetViewController(self, didUpdateTweet: self.tweet!)
                }, failure: { (error) in
                    // TBD add alert controller
                    NSLog("favor of \(self.tweet?.idString) by \((self.tweet!.user?.name)!) failed: \(error.localizedDescription)")
            })
            
        case .Reply:
            performSegueWithIdentifier("replyTweetSegue", sender: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if ("replyTweetSegue" == segue.identifier) {
            let navigationController = segue.destinationViewController as! UINavigationController
            let updateController = navigationController.topViewController as! UpdateViewController
            updateController.userToReply = tweet!.user
        }
    }
}
