//
//  User.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 2/28/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var desc: String?
    
    var profileURL: URL?
    
    var dictionary: NSDictionary
    
    static var userDidLogOutNotification = "UserDidLogOut"
    
    init(dict: NSDictionary){
        
        self.dictionary = dict
        
        // initialize variables of the object
        name = dict["name"] as? String
        screenName = dict["screen_name"] as? String
        desc = dict["description"] as? String
        
        
        
        let pfString = dict["profile_image_url_https"] as? String
        if let pfString = pfString {
            profileURL = URL(string: pfString)
        }
        
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
            
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if userData == nil{
                    print("user data is nil")
                }
                else{
                    print(userData!)
                }
            
                if let userData = userData {
                    if let dict = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as? NSDictionary{
                        print(dict)
                        _currentUser = User(dict: dict)
                    }else{
                        _currentUser = nil
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                
                print("set current user data to something")
                defaults.set(data, forKey: "currentUserData")
                
            } else {
                print("set current user to nil")
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
