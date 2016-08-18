//
//  Answer.swift
//  Mirage
//
//  Created by Oddin on 04/08/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Answer: NSObject {
    
    var id = Int()
    var text = String()
    var anonymous = Bool()
    var created_at = String()
    var accepted = Bool()
    var upvotes = Int()
    var downvotes = Int()
    var my_vote = Int()
}