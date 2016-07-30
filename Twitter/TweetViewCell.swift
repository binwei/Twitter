//
//  TweetViewCell.swift
//  Twitter
//
//  Created by Binwei Yang on 7/30/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    var tweet : Tweet! {
        didSet {
            if let user = tweet.user {
                userNameLabel.text = user.name
                screenNameLabel.text = "@\(user.screenName!)"
                if let profileUrl = user.profileUrl {
                    profileImage.setImageWithURL(profileUrl)
                }
            }
            tweetContentLabel.text = tweet.text
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm y"
            timestampLabel.text = formatter.stringFromDate(tweet.timestamp!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
    }
}
