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
    
    static func iterateJSONArray(_ answer: NSArray) -> Array<Answer> {
        var answers = Array<Answer>()
        
        for i in 0 ..< answer.count {
            let answrs = Answer()
            
            answrs.id = (answer[i] as AnyObject).value(forKey: StringUtil.id) as! Int
            answrs.text = (answer[i] as AnyObject).value(forKey: StringUtil.text) as! String
            answrs.anonymous = (answer[i] as AnyObject).value(forKey: StringUtil.anonymous) as! Bool
            answrs.created_at = (answer[i] as AnyObject).value(forKey: StringUtil.created_at) as! String
            answrs.accepted = (answer[i] as AnyObject).value(forKey: StringUtil.accepted) as! Bool
            answrs.upvotes = (answer[i] as AnyObject).value(forKey: StringUtil.upvotes) as! Int
            answrs.downvotes = (answer[i] as AnyObject).value(forKey: StringUtil.downvotes) as! Int
            answrs.my_vote = (answer[i] as AnyObject).value(forKey: StringUtil.my_vote) as! Int
            
            answers.insert(answrs, at: i)
        }
        
        return answers
    }
}
