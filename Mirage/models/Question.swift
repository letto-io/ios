//
//  Doubt.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Question: NSObject {
    
    var id = Int()
    var text = String()
    var anonymous = Bool()
    var answered = Bool()
    var has_answer = Bool()
    var created_at = String()
    var upvotes = Int()
    var my_vote = Int()
    var presentation = Presentation()
    var person = Person()

    static func iterateJSONArray(_ question: NSArray, presentation: NSArray, person: NSArray) -> Array<Question> {
        var questions = Array<Question>()
        
        for i in 0 ..< question.count {
            let qtn = Question()
            
            for _ in 0 ..< presentation.count {
                qtn.presentation.id = (presentation[i] as AnyObject).value(forKey: StringUtil.id) as! Int
                qtn.presentation.status = (presentation[i] as AnyObject).value(forKey: StringUtil.status) as! Int
                qtn.presentation.created_at = (presentation[i] as AnyObject).value(forKey: StringUtil.created_at) as! String
                qtn.presentation.subject = (presentation[i] as AnyObject).value(forKey: StringUtil.subject) as! String
            }
            
            for _ in 0 ..< person.count {
                qtn.person.id = (person[i] as AnyObject).value(forKey: StringUtil.id) as! Int
                qtn.person.name = (person[i] as AnyObject).value(forKey: StringUtil.name) as! String
            }
            
            qtn.id = (question[i] as AnyObject).value(forKey: StringUtil.id) as! Int
            qtn.text = (question[i] as AnyObject).value(forKey: StringUtil.text) as! String
            qtn.anonymous = (question[i] as AnyObject).value(forKey: StringUtil.anonymous) as! Bool
            qtn.answered = (question[i] as AnyObject).value(forKey: StringUtil.answered) as! Bool
            qtn.has_answer = (question[i] as AnyObject).value(forKey: StringUtil.has_answer) as! Bool
            qtn.created_at = (question[i] as AnyObject).value(forKey: StringUtil.created_at) as! String
            qtn.upvotes = (question[i] as AnyObject).value(forKey: StringUtil.upvotes) as! Int
            qtn.my_vote = (question[i] as AnyObject).value(forKey: StringUtil.my_vote) as! Int
           
            questions.insert(qtn, at: i)
        }
        return questions
    }		
}
