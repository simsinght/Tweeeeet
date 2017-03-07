//
//  TweetDetailsViewController.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 3/6/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favortiesCountLabel: UILabel!
    
    @IBOutlet weak var userPFImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var rtImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextLabel.text = tweet?.text!
        retweetsCountLabel.text = String((tweet?.rtCount)!)
        favortiesCountLabel.text = String((tweet?.favCount)!)
        
        userPFImageView.setImageWith((tweet?.pfImageURL!)!)
        
        userNameLabel.text = tweet?.userName
        userHandleLabel.text = "@" + (tweet?.userHandle)!
        
        timestampLabel.text = String(describing: (tweet?.timestamp)!)
        
        if(tweet?.favorited)!{
            favImageView.image = #imageLiteral(resourceName: "heart-red")
        }
        
        if(tweet?.retweeted)!{
            rtImageView.image = #imageLiteral(resourceName: "retweet-blue")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
        
        let next:ComposeTweetViewController = storyboard?.instantiateViewController(withIdentifier: "compose") as! ComposeTweetViewController
        
        next.startText = userHandleLabel.text!
        print("breaks before reaching here?")
        
        self.navigationController?.present(next, animated: true, completion: nil)
        
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if(tweet?.retweeted)!{
            TwitterClient.sharedInstance?.unretweet(id: (tweet?.id)!, success: { (response: NSDictionary) in
                // self.tweet.favCount = response["favourites_count"] as! Int
                self.tweet?.rtCount = response["retweet_count"] as! Int
                
                self.rtImageView.image = #imageLiteral(resourceName: "retweet-black")
                self.retweetsCountLabel.text = "" + String(describing: self.tweet?.rtCount)
                self.tweet?.retweeted = false
            }, failure: { (error: Error) in
                print("error while unretweeting: \(error.localizedDescription)")
            })
            
        } else {
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id)!, success: { (response: NSDictionary) in
                self.tweet?.rtCount = response["retweet_count"] as! Int
                
                
                self.rtImageView.image = #imageLiteral(resourceName: "retweet-blue")
                //self.favortiesCountLabel.text = "" + String(describing: self.tweet?.favCount)
                self.retweetsCountLabel.text = "" + String(describing: self.tweet?.rtCount)
                self.tweet?.retweeted = true
            }, failure: { (error: Error) in
                print("error while retweeting: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if(tweet?.favorited)!{
            TwitterClient.sharedInstance?.unfavorite(id: (tweet?.id)!, success: { (response: NSDictionary) in
                // let user = response["user"] as? NSDictionary
                // self.tweet.favCount = user?["favourites_count"] as! Int
                self.tweet?.rtCount = response["retweet_count"] as! Int
                
                self.tweet?.favCount -= 1
                self.favImageView.image = #imageLiteral(resourceName: "heart-black")
                //self.favortiesCountLabel.text = String(describing: self.tweet?.favCount)
                //self.retweetsCountLabel.text = String(describing: self.tweet?.rtCount)
                self.tweet?.favorited = false
            }, failure: { (error: Error) in
                print("error while unfavoriting: \(error.localizedDescription)")
            })
            
        } else {
            
            TwitterClient.sharedInstance?.favorite(id: (tweet?.id)!, success: { (response: NSDictionary) in
                // let user = response["user"] as? NSDictionary
                // self.tweet.favCount = user?["favourites_count"] as! Int
                self.tweet?.rtCount = response["retweet_count"] as! Int
                
                self.tweet?.favCount += 1
                self.favImageView.image = #imageLiteral(resourceName: "heart-red")
                //self.favortiesCountLabel.text = String(describing: self.tweet?.favCount)
                //self.retweetsCountLabel.text = String(describing: self.tweet?.rtCount)
                self.tweet?.favorited = true
            }, failure: { (error: Error) in
                print("error while favoriting: \(error.localizedDescription)")
            })
            
            
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
