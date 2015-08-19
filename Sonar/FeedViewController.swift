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
        timelineData.removeAllObjects()
        
        var findTimelineData:PFQuery = PFQuery(className:"Posts")
        println(findTimelineData)
        findTimelineData.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]?, error: NSError?)-> Void in
            
            if error == nil {
                for object in objects! {
                    self.timelineData.addObject(object)
                }
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                println(self.timelineData)
                self.tableView.reloadData()
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            
        } else {
            // Show the signup or login screen
            self.performSegueWithIdentifier("segueToStart", sender: self)
            
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        self.loadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToDetail" {
            let detailVC: FeedDetailViewController = segue.destinationViewController as! FeedDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let cell: FeedTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath!) as! FeedTableViewCell
            let post = self.timelineData.objectAtIndex(indexPath!.row) as! PFObject
            detailVC.postVC = post
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logOutButtonPressed(sender: UIBarButtonItem) {
        PFUser.logOut()
        var currentUser = PFUser.currentUser() // this will now be nil
        self.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FeedTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        let post = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        var dataFormatter: NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM-dd HH:mm"
        cell.timestampLabel.text = dataFormatter.stringFromDate(post.createdAt!)
        // Since post only has the user id
        var findUser = PFUser.query()!
        if let userId = post.objectForKey("user")!.objectId! {
            println(userId)
            findUser.whereKey("objectId", equalTo: userId)
            
            findUser.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]?, error: NSError?)-> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    let user:PFUser = objects.last!
                    cell.usernameLabel.text = user.username
                }
            }
        })
        }
        
        cell.postTextView.text = post.objectForKey("content") as! String


        return cell as UITableViewCell
    }

}
