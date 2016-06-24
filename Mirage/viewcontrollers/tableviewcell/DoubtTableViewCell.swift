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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var understandButton: UIButton!
    @IBOutlet weak var closeDoubt: UIButton!
    @IBOutlet weak var understandLabel: UILabel!
    @IBOutlet weak var countLikesLabel: UILabel!
    var isChecked = Bool()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    @IBAction func understandButtonPressed(sender: AnyObject) {
        // Images
        let checkedImage = ImageUtil.imageCheckBoxMarkedButtonWhite
        let uncheckedImage = ImageUtil.imageCheckBoxButtonWhite
        
        if isChecked == true {
            isChecked = false
            self.understandButton.tintColor = UIColor.grayColor()
        } else {
            isChecked = true
            self.understandButton.tintColor = ColorUtil.orangeColor
        }
        
        if isChecked == true {
            self.understandButton.setImage(checkedImage, forState: .Normal)
        } else {
            self.understandButton.setImage(uncheckedImage, forState: .Normal)
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
