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

    static func iterateJSONArray(question: NSArray, presentation: NSArray, person: NSArray) -> Array<Question> {
        var questions = Array<Question>()
        
        for i in 0 ..< question.count {
            let qtn = Question()
            
            for _ in 0 ..< presentation.count {
                qtn.presentation.id = presentation[i].valueForKey(StringUtil.id) as! Int
                qtn.presentation.status = presentation[i].valueForKey(StringUtil.status) as! Int
                qtn.presentation.created_at = presentation[i].valueForKey(StringUtil.created_at) as! String
                qtn.presentation.subject = presentation[i].valueForKey(StringUtil.subject) as! String
            }
            
            for _ in 0 ..< person.count {
                qtn.person.id = person[i].valueForKey(StringUtil.id) as! Int
                qtn.person.name = person[i].valueForKey(StringUtil.name) as! String
            }
            
            qtn.id = question[i].valueForKey(StringUtil.id) as! Int
            qtn.text = question[i].valueForKey(StringUtil.text) as! String
            qtn.anonymous = question[i].valueForKey(StringUtil.anonymous) as! Bool
            qtn.answered = question[i].valueForKey(StringUtil.answered) as! Bool
            qtn.has_answer = question[i].valueForKey(StringUtil.has_answer) as! Bool
            qtn.created_at = question[i].valueForKey(StringUtil.created_at) as! String
            
            if question[i].upvotes == nil {
                qtn.upvotes = 0
            } else {
                qtn.upvotes = question[i].valueForKey(StringUtil.upvotes) as! Int
            }
            
            qtn.my_vote = question[i].valueForKey(StringUtil.my_vote) as! Int
           
            questions.insert(qtn, atIndex: i)
        }
        return questions
    }		
}
