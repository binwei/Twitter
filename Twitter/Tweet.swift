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
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favourite_count"] as? Int) ?? 0
        
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        if let userDictionary = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDictionary)
        }
        
        if let retweetStatus = dictionary["retweet_status"] as? NSDictionary {
            if let retweetUserDictionary = retweetStatus["user"] as? NSDictionary {
                self.retweetUser = User(dictionary: retweetUserDictionary)
                print("Got retweet from \(retweetUser?.name) for \(user?.name): \(text)")
            }
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
