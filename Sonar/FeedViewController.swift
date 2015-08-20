//
//  FeedViewController.swift
//  Sonar
//
//  Created by Brian Endo on 8/18/15.
//  Copyright (c) 2015 Brian Endo. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var timelineData:NSMutableArray = NSMutableArray()
    
    func loadData() {
        
        // remove all objects so that screen does not have old content
        timelineData.removeAllObjects()
        
        // PFQuery for all of the posts
        var findTimelineData:PFQuery = PFQuery(className:"Posts")
        
        // findTimelineData is an array of objects
        findTimelineData.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]?, error: NSError?)-> Void in
            
            if error == nil {
                // loop around all the objects and add them to timelineData array
                for object in objects! {
                    self.timelineData.addObject(object)
                }
                // put the posts(object containing different key values) in 
                // reverse order so newest is first
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                
                // Change from NSArray to NSMutableArray
                self.timelineData = NSMutableArray(array: array)
                
                // add Post objects to tableView
                self.tableView.reloadData()
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Check if the user is logged in, if not send to StartScreen
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            
        } else {
            // Show the signup or login screen
            self.performSegueWithIdentifier("segueToStart", sender: self)
            
        }
        
        
    }
    override func viewDidAppear(animated: Bool) {
        // Initialize tableView since there is a parent view controller
        tableView.delegate = self
        tableView.dataSource = self
        
        // Call the loadData function
        self.loadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Send Post object to FeedDetailViewController
        if segue.identifier == "segueToDetail" {
            // Creates detailVC which can access FeedDetail variables and properties
            let detailVC: FeedDetailViewController = segue.destinationViewController as! FeedDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            
            // User indexPath to access timelineArray and pull Post object
            let post = self.timelineData.objectAtIndex(indexPath!.row) as! PFObject
            
            // Set postVC from detailVC to the current Post object
            detailVC.postVC = post
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logOutButtonPressed(sender: UIBarButtonItem) {
        // Log out of current user
        PFUser.logOut()
        var currentUser = PFUser.currentUser() // this will now be nil
        
        // Need to reload to reflect no user
        self.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1 section for posts... maybe add new section for user posts
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Count of timelineData array
        return timelineData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Make variable for tableviewcell
        let cell: FeedTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        // Access Post object from timeline array
        let post = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        // Format date
        var dataFormatter: NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM-dd HH:mm"
        
        // Pull from post.createdAt and format data...Eventually want minutes ago
        cell.timestampLabel.text = dataFormatter.stringFromDate(post.createdAt!)
        
        // Query to find user
        var findUser = PFUser.query()!
        
        // Needed if let block to unwrap userID
        // Obtained userID from User object
        if let userId = post.objectForKey("user")!.objectId! {
//            println(userId)
            findUser.whereKey("objectId", equalTo: userId)
            
            // Block to pull individual User object
            findUser.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]?, error: NSError?)-> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    // Multiple instances of the same user
                    // Pulls one instance with last method
                    let user:PFUser = objects.last!
                    
                    // Access the username from User object for usernameLabel
                    cell.usernameLabel.text = user.username
                }
            }
        })
        }
        
        // Pull content string to fill postTextView
        cell.postTextView.text = post.objectForKey("content") as! String

        
        return cell as UITableViewCell
    }

}
