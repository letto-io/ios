//
//  Presentation.swift
//  Mirage
//
//  Created by Siena Idea on 30/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Presentation: NSObject {
    
    var id = Int()
    var status = Int()
    var created_at = String()
    var subject = String()
    var instruction = Instruction()
    var person = Person()
    
    
    static func iterateJSONArray(presentation: NSArray, instruction: NSArray, person: NSArray) -> Array<Presentation> {
        var presentations = Array<Presentation>()
        
        for i in 0 ..< presentation.count {
            let present = Presentation()
            
            for _ in 0 ..< instruction.count {
                present.instruction.id = instruction[i].valueForKey(StringUtil.id) as! Int
                present.instruction.class_number = instruction[i].valueForKey(StringUtil.class_number) as! Int
                present.instruction.start_date = instruction[i].valueForKey(StringUtil.start_date) as! String
                present.instruction.end_date = instruction[i].valueForKey(StringUtil.end_date) as! String
            }
            
            for _ in 0 ..< person.count {
                present.person.id = person[i].valueForKey(StringUtil.id) as! Int
                present.person.name = person[i].valueForKey(StringUtil.name) as! String
            }
            
            present.id = presentation[i].valueForKey(StringUtil.id) as! Int
            present.created_at = presentation[i].valueForKey(StringUtil.created_at) as! String
            present.status = presentation[i].valueForKey(StringUtil.status) as! Int
            present.subject = presentation[i].valueForKey(StringUtil.subject) as! String
            
            presentations.insert(present, atIndex: i)
        }
        
        return presentations
    }
}
