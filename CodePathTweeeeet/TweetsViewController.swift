//
//  TweetsViewController.swift
//  CodePathTweeeeet
//
//  Created by Simrandeep Singh on 2/28/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit



class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, tweetsCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    
    var refreshControl: UIRefreshControl?
    var tempUDict: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let client = TwitterClient.sharedInstance
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)
        
        client?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    
    /* functions for creating the cell */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! tweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        TwitterClient.sharedInstance?.homeTimeline(maxid: tweets[tweets.count - 1].id,success: { (tweets: [Tweet]) in
            self.tweets += tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    
    func tweetCellDelegate(userDict: NSDictionary) {
        tempUDict = userDict
        print("function called")
        
        let next:ProfileViewController = storyboard?.instantiateViewController(withIdentifier: "userProfile") as! ProfileViewController
        next.userDict = self.tempUDict
        print("breaks before reaching here?")
        
        self.navigationController?.show(next, sender: nil)

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell {
        
            let indexPath = tableView.indexPath(for: cell)
            tableView.deselectRow(at: indexPath!, animated: true)
            
            let tweet = tweets[(indexPath?.row)!]
            
            
            let tweetDetailsViewController = segue.destination as! TweetDetailsViewController
            
            tweetDetailsViewController.tweet = tweet
        }
        
        else if sender == nil {
            print("prepare - sender nil")
            let controller = segue.destination as! ProfileViewController
            controller.userDict = self.tempUDict
        }
        
    }
 

}
