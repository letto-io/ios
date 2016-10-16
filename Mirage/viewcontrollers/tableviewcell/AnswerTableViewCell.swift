//
//  AnswerTableViewCell.swift
//  Mirage
//
//  Created by Oddin on 29/08/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var materialImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
