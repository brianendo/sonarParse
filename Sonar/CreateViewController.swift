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
        
        createTextView.layer.borderColor = UIColor.blackColor().CGColor
        createTextView.layer.borderWidth = 0.5
        createTextView.layer.cornerRadius = 5
        createTextView.delegate = self
        
        createTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneBarButtonePressed(sender: AnyObject) {
        
        var post:PFObject = PFObject(className:"Posts")
        post["content"] = createTextView.text
        post["user"] = PFUser.currentUser()
        post.saveInBackground()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var newLength: Int = (textView.text as NSString).length + (text as NSString).length - range.length
        var remainingChar: Int = 100 - newLength
        
        charRemainingLabel.text = "\(remainingChar)"
        
        return (newLength > 100) ? false : true
        
    }

    
}
