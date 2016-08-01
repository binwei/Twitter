//
//  Tweet.swift
//  Twitter
//
//  Created by Binwei Yang on 7/28/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User?
    var retweetUser: User?
    var idString: String?
    
    init(dictionary origDictionary: NSDictionary) {
        var dictionary = origDictionary
        
        if let retweetStatus = origDictionary["retweeted_status"] as? NSDictionary {
            if let userDictionary = origDictionary["user"] as? NSDictionary {
                retweetUser = User(dictionary: userDictionary)
            }
            
            dictionary = retweetStatus
        }
        
        idString = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        if let userDictionary = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDictionary)
        }
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
