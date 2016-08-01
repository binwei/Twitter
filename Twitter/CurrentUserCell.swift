//
//  CurrentUserCell.swift
//  Twitter
//
//  Created by Binwei Yang on 7/31/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit
import AFNetworking

class CurrentUserCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let user = User.currentUser {
            nameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName!)"
            
            userImageView.setImageWithURL(user.profileUrl!)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
