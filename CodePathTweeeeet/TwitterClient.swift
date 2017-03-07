//
//  TwitterClient.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 2/28/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "pUYGxi4SWIsaSBA06dLa6dT1v", consumerSecret: "GeZqdOO4XS470nSd6Hwp0FEybyNnXp0fQwF3q1ML0GV3uDqJrk")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()->(), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "CodePathTweeeeet://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("connected to twitter")
            print(requestToken?.token! ?? "fuck this")
            let authorizeURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + (requestToken?.token)!)!
            UIApplication.shared.open(authorizeURL)
            
        }, failure: { (error: Error?) in
            print("error connecting to twitter")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogOutNotification), object: nil)
    }
    
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("I got the access token")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }, failure: { (error: Error?) in
            print("Error fetching access token: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func homeTimeline(maxid: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json?max_id=\(maxid)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil , progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            // assign response as a dictionary
            let userDictionary = response as! NSDictionary
            // create/fill the model/class
            let user = User(dict: userDictionary)
            // just to test if it worked
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func retweet(id: String,success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            success(tweetDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweet(id: String,success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            success(tweetDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(id: String,success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            success(tweetDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unfavorite(id: String,success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            success(tweetDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func tweet(status: String,success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json?status=\(status)", parameters: nil, progress: nil, success: { (URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            success(tweetDictionary)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func userTimeline(userID: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/user_timeline.json?screen_name=\(userID)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

}
