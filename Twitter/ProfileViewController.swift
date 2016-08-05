//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 8/3/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var profileImageTopConstraint: NSLayoutConstraint!
    
    var user: User? {
        didSet {
            if let user = user {
                TwitterClient.sharedInstance.userTimeline(user, success: { (tweets) in
                    self.tweets = tweets
                    
                    self.profileTableView.reloadData()
                    
                    self.profileImageView.setImageWithURL(user.profileUrl!)
                    self.nameLabel.text = user.name
                    self.screenNameLabel.text = "@\(user.screenName!)"
                    self.tagLineLabel.text = user.tagLine
                    
                    print("\(user.tagLine ) followers cnt \(user.followersCount!) friends cnt \(user.friendsCount!) tweets cnt \(user.tweetsCount)")
                    
                    self.tweetsCountLabel.text = self.countText(user.tweetsCount!)
                    self.followingCountLabel.text = self.countText(user.friendsCount!)
                    self.followersCountLabel.text = self.countText(user.followersCount!)
                    
                    if let bannerImageUrl = user.profileBannerUrl {
                        self.bannerImageView.setImageWithURL(bannerImageUrl)
                        self.headerView.sendSubviewToBack(self.bannerImageView)
                    } else {
                        self.profileImageTopConstraint.constant = 8
                    }
                    
                    self.navigationItem.title = user.name
                    }, failure: { (error) in
                        NSLog("Failed to get timeline: \(error.localizedDescription)")
                })
            }
        }
    }
    
    private func countText(count: Int) -> String! {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        if (count < 10000) {
            return formatter.stringFromNumber(count)
        } else if (count < 1000000) {
            formatter.maximumFractionDigits = 1
            return "\(formatter.stringFromNumber(Double(count) / 1000)!)K"
        } else {
            formatter.maximumFractionDigits = 2
            return "\(formatter.stringFromNumber(Double(count) / 1000000)!)M"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.estimatedRowHeight = 120
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tweets"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
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
