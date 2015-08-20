//
//  CreateViewController.swift
//  Sonar
//
//  Created by Brian Endo on 8/18/15.
//  Copyright (c) 2015 Brian Endo. All rights reserved.
//

import UIKit
import Parse

class CreateViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var createTextView: UITextView!
    
    @IBOutlet weak var charRemainingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Formatting for the textView
        createTextView.layer.borderColor = UIColor.blackColor().CGColor
        createTextView.layer.borderWidth = 0.5
        createTextView.layer.cornerRadius = 5
        
        // Need to abide by UITextViewDelegate
        createTextView.delegate = self
        
        // Starts typing in TextView and opens keyboard
        createTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneBarButtonePressed(sender: AnyObject) {
        
        // Create Post object in Posts table
        var post:PFObject = PFObject(className:"Posts")
        post["content"] = createTextView.text
        // Accesses the currentUser object to create relation
        post["user"] = PFUser.currentUser()
        
        // Save the object to database
        post.saveInBackground()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Limit character limit to 100
        var newLength: Int = (textView.text as NSString).length + (text as NSString).length - range.length
        var remainingChar: Int = 100 - newLength
        
        // Make label show remaining characters
        charRemainingLabel.text = "\(remainingChar)"
        
        // Once text > 100 chars, stop ability to change text
        return (newLength > 100) ? false : true
        
    }

    
}
