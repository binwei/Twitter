//
//  User.swift
//  Twitter
//
//  Created by Binwei Yang on 7/28/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

class User: NSObject {
    var idString: String?
    var name: String?
    var screenName: String?
    var profileUrl: NSURL?
    var tagLine: String?
    var followersCount: Int?
    var friendsCount: Int?
    var tweetsCount: Int?
    var profileBannerUrl: NSURL?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        idString = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        if let profileBannerUrlString = dictionary["profile_banner_url"] as? String {
            profileBannerUrl = NSURL(string: profileBannerUrlString)
        }
        
        tagLine = dictionary["description"] as? String
        
        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static let currentUserKey = "currentUserJson"
    static var _cachedCurrentUser: User?
    
    class var currentUser: User? {
        get {
            if (nil == _cachedCurrentUser) {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let data = defaults.objectForKey(currentUserKey) as? NSData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                    _cachedCurrentUser = User(dictionary: dictionary)
                }
            }
            
            return _cachedCurrentUser
        }
        set (user) {
            _cachedCurrentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: currentUserKey)
            }
            else {
                defaults.setObject(nil, forKey: currentUserKey)
            }
            
            defaults.synchronize()
        }
    }
}
