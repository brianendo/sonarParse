//
//  FeedDetailViewController.swift
//  Sonar
//
//  Created by Brian Endo on 8/18/15.
//  Copyright (c) 2015 Brian Endo. All rights reserved.
//

import UIKit
import Parse

class FeedDetailViewController: UIViewController {
    
    // Create Object to pull from feedView
    var postVC: PFObject?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postTextView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use PostObject selected from feedView
        var post = postVC!
        
        // Pull date from post foor dateLabel
        var dataFormatter: NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM-dd HH:mm"
        self.dateLabel.text = dataFormatter.stringFromDate(post.createdAt!)
        
        // Post has the User object so must query into object to get userId
        var findUser = PFUser.query()!
        if let userId = post.objectForKey("user")!.objectId! {
            
//            println(userId)
            
            findUser.whereKey("objectId", equalTo: userId)
            
            findUser.findObjectsInBackgroundWithBlock({
                (objects:[AnyObject]?, error: NSError?)-> Void in
                if error == nil {
                    if let objects = objects as? [PFUser] {
                        let user:PFUser = objects.last!
                        self.usernameLabel.text = user.username
                    }
                }
            })
        }
        
        self.postTextView.text = post.objectForKey("content") as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
