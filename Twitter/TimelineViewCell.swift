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
                    profileImageView.setImageWithURL(profileUrl)
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
//            print("done calling didSet for \(row) \(nameLabel.text)")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        configureLabelWidth()
//        print("done calling awakeFromNib for \(row) \(nameLabel.text)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureLabelWidth()
        
//        print("done calling layoutSubviews for \(row) \(nameLabel.text)")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        configureLabelWidth()
//        print("done calling setSelected = \(selected) \(row) \(nameLabel.text)")
    }
    
    // calls to functions above are interleaved, as cells come in and out of view
    // also cells are reused, so make this call whenever cells are selected/deselected
    private func configureLabelWidth() {
        contentTextLabel.preferredMaxLayoutWidth = contentTextLabel.frame.size.width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
    }
}
