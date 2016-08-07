//
//  TimelineViewCell.swift
//  Twitter
//
//  Created by Binwei Yang on 7/29/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit
import AFNetworking

class TimelineViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var contentTextLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    var row: Int!
    
    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                nameLabel.text = user.name
                screenNameLabel.text = "@\(user.screenName!)"
                if let profileUrl = user.profileUrl {
                    profileImageView.setImageWithURLRequest(NSURLRequest(URL: profileUrl), placeholderImage: nil, success: { (request, response, image) in
                        self.profileImageView.alpha = 0.0
                        self.profileImageView.image = image
                        UIView.animateWithDuration(0.3, animations: {
                            self.profileImageView.alpha = 1.0
                        })
                        }, failure: { (request, response, error) in
                            self.profileImageView.image = nil
                            NSLog("Failed to get image: \(error.localizedDescription)")
                    })
                }
            }
            contentTextLabel.text = tweet.text
            retweetCountLabel.text = "\(tweet.retweetCount)"
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
            
            let dateComponentsFormatter = NSDateComponentsFormatter()
            dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
            let timeInterval = NSDate().timeIntervalSinceDate(tweet.timestamp!)
            if (timeInterval < 3600) {
                let timeIntervalInMinutes = Int((timeInterval / 60))
                elapsedTimeLabel.text = dateComponentsFormatter.stringFromTimeInterval(Double(timeIntervalInMinutes * 60))
            } else {
                let timeIntervalInHours = Int((timeInterval / 3600))
                elapsedTimeLabel.text = dateComponentsFormatter.stringFromTimeInterval(Double(timeIntervalInHours * 3600))
            }
            
            
            if let retweetUserName = tweet.retweetUser?.name {
                print("Got retweet from \(retweetUserName) for \((tweet.user?.name)!) at \(row)")
            }
            
            configureLabelWidth()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        configureLabelWidth()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureLabelWidth()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        configureLabelWidth()
    }
    
    // calls to functions above are interleaved, as cells come in and out of view
    // also cells are reused, so make this call whenever cells are selected/deselected
    private func configureLabelWidth() {
        contentTextLabel.preferredMaxLayoutWidth = contentTextLabel.frame.size.width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
    }
}
