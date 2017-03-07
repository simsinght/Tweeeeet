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
        userHandleLabel.text = tweet?.userHandle
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
