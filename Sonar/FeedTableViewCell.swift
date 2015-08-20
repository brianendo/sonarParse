//
//  FeedTableViewCell.swift
//  Sonar
//
//  Created by Brian Endo on 8/18/15.
//  Copyright (c) 2015 Brian Endo. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    
    // Made outlets for TableViewCell...Edited in FeedVC
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var postTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
