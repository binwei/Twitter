//
//  TweetCountsCell.swift
//  Twitter
//
//  Created by Binwei Yang on 7/30/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

enum TweetAction {
    case Reply, Retweet, Favor
}

protocol TweetCountsCellDelete {
    func tweetCountsCell(tweetCountsCell: TweetCountsCell, didTweetAction tweetAction: TweetAction)
}

class TweetCountsCell: UITableViewCell {
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var delegate: TweetCountsCellDelete?
    
    @IBAction func onReplyButton(sender: UIButton) {
        delegate?.tweetCountsCell(self, didTweetAction: .Reply)
    }
    
    @IBAction func onFavorButton(sender: UIButton) {
        delegate?.tweetCountsCell(self, didTweetAction: .Favor)
    }
    
    @IBAction func onRetweetButton(sender: UIButton) {
        delegate?.tweetCountsCell(self, didTweetAction: .Retweet)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
