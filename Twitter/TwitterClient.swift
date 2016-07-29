//
//  TwitterClient.swift
//  Twitter
//
//  Created by Binwei Yang on 7/28/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(
        baseURL: NSURL(string: "https://api.twitter.com")!,
        consumerKey: "ueyodt9Vt8eAlwUvo9RrAHrjt",
        consumerSecret: "gpnDdVoue413qV3X9DR2IsUdUzkNNc5vd1bGURV1ZrxAQbyXq7")
    
    var loginSuccessHandler: (() -> ())?
    var loginFailureHandler: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        // starting the login process
        self.loginSuccessHandler = success
        self.loginFailureHandler = failure
        
        // reset login session
        deauthorize()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://com.yang.oauth"), scope: nil, success: { (requestToken) in
            
            NSLog("login success with request token \(requestToken.token)")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error) in
            print("Login request token error: \(error.localizedDescription)")
            self.loginFailureHandler?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            
            NSLog("login success with access token \(accessToken)")
            
            // remember the current user
            self.currentAccount({ (user) in
                User.currentUser = user
                
                // finish login session
                self.loginSuccessHandler?()
                
                }, failure: { (error) in
                    self.loginFailureHandler?(error)
            })
            
        }) { (error) in
            print("Login access token error: \(error.localizedDescription)")
            self.loginFailureHandler?(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        self.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            NSLog("currentAccount success with user: \(userDictionary)")
            
            success(user)
        }) { (task, error) in
            failure(error)
        }
    }
    
    func homeTimeline(success: ([Tweet] -> ()), failure: (NSError) -> ()) {
        self.GET("1.1/account/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsFromArray(dictionaries)
            
            NSLog("homeTimeline success with \(tweets.count) tweets")
            
            success(tweets)
        }) { (task, error) in
            failure(error)
        }
    }
}
