//
//  PresentationTableViewCell.swift
//  Mirage
//
//  Created by Siena Idea on 04/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class PresentationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var closePresentationButton: UIButton!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
