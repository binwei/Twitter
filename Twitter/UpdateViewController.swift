//
//  UpdateViewController.swift
//  Twitter
//
//  Created by Binwei Yang on 7/31/16.
//  Copyright © 2016 Binwei Yang. All rights reserved.
//

import UIKit

protocol UpdateViewControllerDelegate: class {
    func updateViewController(updateViewController: UpdateViewController, didUpdateTweet tweet: Tweet)
}

class UpdateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var updateTableView: UITableView!
    
    var tweetToReply: Tweet?
    var textToSend: String?
    var wordCountLabel: UILabel?
    let characterCountLimit = 140
    
    weak var delegate: UpdateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateTableView.delegate = self
        updateTableView.dataSource = self
        
        updateTableView.estimatedRowHeight = 100
        updateTableView.rowHeight = UITableViewAutomaticDimension
        
        if let navigationBar = self.navigationController?.navigationBar {
            let wordCountFrame = CGRect(x: navigationBar.frame.width/2, y: 0, width: navigationBar.frame.width/4, height: navigationBar.frame.height)
            
            let wordCountLabel = UILabel(frame: wordCountFrame)
            wordCountLabel.textAlignment = NSTextAlignment.Right
            wordCountLabel.alpha = 0.4
            wordCountLabel.font = UIFont(name: ".SFUIText-Regular", size: 14.0)
            self.wordCountLabel = wordCountLabel
            
            navigationBar.addSubview(wordCountLabel)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 && nil == tweetToReply) {
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell =  tableView.dequeueReusableCellWithIdentifier("replyToCell", forIndexPath: indexPath) as! ReplyToUserCell
            cell.replyToUserLabel.text = "in reply to \(tweetToReply!.user!.name!) @\(tweetToReply!.user!.screenName!)"
            return cell
        case 1:
            return tableView.dequeueReusableCellWithIdentifier("currentUserCell", forIndexPath: indexPath)
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetEditCell", forIndexPath: indexPath) as! TweetUpdateCell
            cell.updateTextField.delegate = self
            
            return cell
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textToSend = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // We need to figure out how many characters would be in the string after the change happens
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace = range.length
        
        var newLength = startingLength + lengthToAdd - lengthToReplace
        
        if let screenName = tweetToReply?.user?.screenName {
            newLength += screenName.characters.count + 2
        }
        
        if (newLength <= characterCountLimit) {
            wordCountLabel?.text = "\(newLength)"
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func onTweetButton(sender: UIBarButtonItem) {
        if let content = textToSend {
            if (nil == tweetToReply) {
                TwitterClient.sharedInstance.updateStatus(content, inReplyTo: nil, success: { (tweet) in
                    self.delegate?.updateViewController(self, didUpdateTweet: tweet)
                    }, failure: { (error) in
                        NSLog("Failed to tweet: \(error.localizedDescription)")
                })
            }
            else {
                TwitterClient.sharedInstance.updateStatus("@\(tweetToReply!.user!.screenName!) \(content)", inReplyTo: tweetToReply?.idString, success: { (tweet) in
                    self.delegate?.updateViewController(self, didUpdateTweet: tweet)
                    }, failure: { (error) in
                        NSLog("Failed to reply to tweet: \(error.localizedDescription)")
                })
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
