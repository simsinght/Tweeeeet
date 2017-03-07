//
//  Tweet.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 2/28/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var userName: String?
    var userHandle: String?
    var id: String
    
    var text: String?
    var timestamp: Date?
    var pfImageURL: URL?
    
    var retweeted = false
    var rtCount = 0
    
    
    var favorited = false
    var favCount = 0
    
    var dictionary: NSDictionary?
    var user: NSDictionary?
 
    init( dict: NSDictionary ){
        dictionary = dict
        let user = dict["user"] as? NSDictionary
        self.user = user
        userName = user?["name"] as? String
        userHandle = user?["screen_name"] as? String
        
        text = dict["text"] as? String
        
        retweeted = (dict["retweeted"] as? Bool)!
        rtCount = (dict["retweet_count"] as? Int) ?? 0
        
        favorited = (dict["favorited"] as? Bool)!
        
        favCount = (dict["favorite_count"] as? Int) ?? 0
        print(dict["favorite_count"]!)
        
        let timestampString = dict["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        var imageURLString = user?["profile_image_url"] as? String
        if imageURLString != nil {
            let index = imageURLString?.index((imageURLString?.startIndex)!, offsetBy: 4)
            imageURLString = "https" + (imageURLString?.substring(from: index!))!
            pfImageURL = URL(string: imageURLString!)!
        } else {
            pfImageURL = nil
        }
        
        id = (dict["id_str"] as? String)!
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dict: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
