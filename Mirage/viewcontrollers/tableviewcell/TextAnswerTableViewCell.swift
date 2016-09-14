//
//  TextAnswerTableViewCell.swift
//  Mirage
//
//  Created by Oddin on 29/08/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class TextAnswerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textAnswerLabel: UILabel!
    @IBOutlet weak var countVotesLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
