//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 7/29/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetViewControllerDelegate, UpdateViewControllerDelegate {
    var tweets: [Tweet]?
    
    @IBOutlet weak var timelineTableView: UITableView!
    
    var needReloadAfterAppear  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        timelineTableView.rowHeight = UITableViewAutomaticDimension
        timelineTableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) in
            self.tweets = tweets
            
            self.timelineTableView.reloadData()
        }) { (error:NSError) in
            NSLog("Failed to get timeline: \(error.localizedDescription)")
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        timelineTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        if (needReloadAfterAppear) {
            timelineTableView.reloadData()
            needReloadAfterAppear = false
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) in
            self.tweets = tweets
            
            self.timelineTableView.reloadData()
            
            refreshControl.endRefreshing()
            print("Refreshing completed with \(self.tweets!.count) tweets")
        }) { (error:NSError) in
            NSLog("Failed to get timeline: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onSignOutButton(sender: UIBarButtonItem) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets?.count) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineViewCell", forIndexPath: indexPath) as! TimelineViewCell
        
        cell.row = indexPath.row
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if ("tweetSegue" == segue.identifier) {
            let tweetController = segue.destinationViewController as! TweetViewController
            
            let cell = sender as! TimelineViewCell
            let indexPath = timelineTableView.indexPathForCell(cell)
            
            let tweet  = tweets![(indexPath?.row)!]
            tweetController.tweet = tweet
            tweetController.delegate = self
        } else if ("newTweetSegue" == segue.identifier) {
            let navigationController = segue.destinationViewController as! UINavigationController
            let updateController = navigationController.topViewController as! UpdateViewController
            updateController.delegate = self
        }
    }
    
    func tweetViewController(tweetViewController: TweetViewController, didUpdateTweet tweet: Tweet) {
        if let index = tweets?.indexOf({ (currentTweet: Tweet) -> Bool in
            return currentTweet.idString == tweet.idString
        }) {
            tweets![index] = tweet
            needReloadAfterAppear = true
        }
    }
    
    func tweetViewController(tweetViewController: TweetViewController, didCreateTweet tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        needReloadAfterAppear = true
    }

    func updateViewController(updateViewController: UpdateViewController, didUpdateTweet tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        needReloadAfterAppear = true
    }
}
