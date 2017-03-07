//
//  tweetCell.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 2/28/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit

@objc protocol tweetsCellDelegate {
    @objc optional func tweetCellDelegate( userDict: NSDictionary )
}

class tweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var rtCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    
    @IBOutlet weak var userPFImageView: UIImageView!
    @IBOutlet weak var rtImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    
    weak var delegate: tweetsCellDelegate?
    
    var tweet: Tweet! {
        didSet{
            tweetTextLabel.text = tweet.text!
            rtCountLabel.text = String(tweet.rtCount)
            favCountLabel.text = String(tweet.favCount)
            
            userPFImageView.setImageWith(tweet.pfImageURL!)
            
            if(tweet.favorited){
                favImageView.image = #imageLiteral(resourceName: "heart-red")
            }
            
            if(tweet.retweeted){
                rtImageView.image = #imageLiteral(resourceName: "retweet-blue")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        
        if(tweet.retweeted){
            TwitterClient.sharedInstance?.unretweet(id: tweet.id, success: { (response: NSDictionary) in
                // self.tweet.favCount = response["favourites_count"] as! Int
                self.tweet.rtCount = response["retweet_count"] as! Int
                
                self.rtImageView.image = #imageLiteral(resourceName: "retweet-black")
                self.rtCountLabel.text = String(self.tweet.rtCount)
                self.tweet.retweeted = false
            }, failure: { (error: Error) in
                print("error while unretweeting: \(error.localizedDescription)")
            })
            
        } else {
            TwitterClient.sharedInstance?.retweet(id: tweet.id, success: { (response: NSDictionary) in
                self.tweet.rtCount = response["retweet_count"] as! Int
                
                
                self.rtImageView.image = #imageLiteral(resourceName: "retweet-blue")
                self.favCountLabel.text = String(self.tweet.favCount)
                self.rtCountLabel.text = String(self.tweet.rtCount)
                self.tweet.retweeted = true
            }, failure: { (error: Error) in
                print("error while retweeting: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if(tweet.favorited){
            TwitterClient.sharedInstance?.unfavorite(id: tweet.id, success: { (response: NSDictionary) in
                // let user = response["user"] as? NSDictionary
                // self.tweet.favCount = user?["favourites_count"] as! Int
                self.tweet.rtCount = response["retweet_count"] as! Int
                
                self.tweet.favCount -= 1
                self.favImageView.image = #imageLiteral(resourceName: "heart-black")
                self.favCountLabel.text = String(self.tweet.favCount)
                self.rtCountLabel.text = String(self.tweet.rtCount)
                self.tweet.favorited = false
            }, failure: { (error: Error) in
                print("error while unfavoriting: \(error.localizedDescription)")
            })
            
        } else {
            
            TwitterClient.sharedInstance?.favorite(id: tweet.id, success: { (response: NSDictionary) in
                // let user = response["user"] as? NSDictionary
                // self.tweet.favCount = user?["favourites_count"] as! Int
                self.tweet.rtCount = response["retweet_count"] as! Int
                
                self.tweet.favCount += 1
                self.favImageView.image = #imageLiteral(resourceName: "heart-red")
                self.favCountLabel.text = String(self.tweet.favCount)
                self.rtCountLabel.text = String(self.tweet.rtCount)
                self.tweet.favorited = true
            }, failure: { (error: Error) in
                print("error while favoriting: \(error.localizedDescription)")
            })
            
            
            
        }
        
    }
    
    
    @IBAction func onPFRetweet(_ sender: Any) {
        onRetweetButton(sender)
    }
    
    @IBAction func onPFFavorite(_ sender: Any) {
        onFavoriteButton(sender)
    }
    
    
    @IBAction func onUserImageButton(_ sender: Any) {
        print("pressed")
        delegate?.tweetCellDelegate!(userDict: tweet.user!)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
