//
//  userTableViewCell.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 3/7/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit

class userTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var pfImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var userDescLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
    var userDict: NSDictionary! {
        didSet{
            userName.text = userDict["name"] as? String
            userHandle.text = userDict["screen_name"] as? String
            
            userDescLabel.text = userDict["description"] as? String
            
            let pfUrl = URL(string: (userDict["profile_image_url_https"] as! String))
            pfImage.setImageWith(pfUrl!)
            
            if(userDict["profile_use_background_image"] as? Bool)!{
                let bnUrl = URL(string: (userDict["profile_background_image_url_https"] as? String)!)
                bannerImage.setImageWith(bnUrl!)
            }
            
            let followers = String(describing: userDict["followers_count"] as! Int)
            let following = String(describing: userDict["friends_count"] as! Int)
            let tweets = String(describing: userDict["statuses_count"] as! Int)
            
            
            followingCountLabel.text =  "" + following
            followersCountLabel.text = "" + followers
            tweetsCountLabel.text = "" + tweets
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
