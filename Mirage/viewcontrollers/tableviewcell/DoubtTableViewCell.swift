//
//  DoubtTableViewCell.swift
//  Mirage
//
//  Created by Siena Idea on 02/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class DoubtTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textDoubtLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var understandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
