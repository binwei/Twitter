//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 8/4/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mentionsTableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mentionsTableView.dataSource = self
        mentionsTableView.delegate = self
        
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        mentionsTableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.mentionsTimeline({ (tweets:[Tweet]) in
            self.tweets = tweets
            
            self.mentionsTableView.reloadData()
        }) { (error:NSError) in
            NSLog("Failed to get mentions: \(error.localizedDescription)")
        }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
