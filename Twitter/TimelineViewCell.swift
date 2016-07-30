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
    
    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                nameLabel.text = user.name
                screenNameLabel.text = user.screenName
                if let profileUrl = user.profileUrl {
                    profileImageView.setImageWithURL(profileUrl)
                }
            }
            contentTextLabel.text = tweet.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        contentTextLabel.preferredMaxLayoutWidth = contentTextLabel.frame.size.width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
        print("done calling awakeFromNib for \(nameLabel.text)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentTextLabel.preferredMaxLayoutWidth = contentTextLabel.frame.size.width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
        print("done calling layoutSubviews for \(nameLabel.text)")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        contentTextLabel.preferredMaxLayoutWidth = contentTextLabel.frame.size.width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
        print("done calling setSelected for \(nameLabel.text) with \(selected)")
    }
    
}
