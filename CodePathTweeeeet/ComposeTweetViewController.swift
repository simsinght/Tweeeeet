//
//  ComposeTweetViewController.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 3/6/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextViewInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tweetTextViewInput.delegate = self
        _ = tweetTextViewInput.delegate?.textViewShouldBeginEditing!(tweetTextViewInput)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        let urlReq = tweetTextViewInput.text
        let urlNew = urlReq?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        TwitterClient.sharedInstance?.tweet(status: urlNew!, success: { (NSDictionary) in
            print("running out of time")
        }, failure: { (Error) in
            print("failed to tweet")
        })
        
        dismiss(animated: true, completion: nil)
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
