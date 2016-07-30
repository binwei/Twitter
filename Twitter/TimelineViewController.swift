//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 7/29/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]?
    
    @IBOutlet weak var timelineTableView: UITableView!
    
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
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if ("tweetSegue" == segue.identifier) {
            let tweetController = segue.destinationViewController as! TweetViewController
            
            let cell = sender as! TimelineViewCell
            let indexPath = timelineTableView.indexPathForCell(cell)
            
            tweetController.tweet = tweets![(indexPath?.row)!]
        }
    }
}
