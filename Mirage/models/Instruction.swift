//
//  Instruction.swift
//  Mirage
//
//  Created by Oddin on 02/08/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Instruction: NSObject {
    
    var id = Int()
    var classNumber = Int()
    var startDate = String()
    var endDate = String()
    var event = Event()
    var lecture = Lecture()
    
    
    static func iterateJSONArray(instruction: NSArray, lecture: NSArray, event: NSArray) -> Array<Instruction> {
        var instructions = Array<Instruction>()
        
        for i in 0 ..< instruction.count {
            let instruct = Instruction()
            
            for _ in 0 ..< event.count {
                instruct.event.id = event[i].valueForKey(StringUtil.id) as! Int
                instruct.event.code = event[i].valueForKey(StringUtil.code) as! String
                instruct.event.name = event[i].valueForKey(StringUtil.name) as! String
                instruct.event.workload = event[i].valueForKey(StringUtil.workload) as! String
                
            }
            
            for _ in 0 ..< lecture.count {
                instruct.lecture.id = lecture[i].valueForKey(StringUtil.id) as! Int
                instruct.lecture.code = lecture[i].valueForKey(StringUtil.code) as! String
                instruct.lecture.name = lecture[i].valueForKey(StringUtil.name) as! String
                instruct.lecture.workload = lecture[i].valueForKey(StringUtil.workload) as! String
            }
            
            instruct.id = instruction[i].valueForKey(StringUtil.id) as! Int
            instruct.startDate = instruction[i].valueForKey(StringUtil.start_date) as! String
            instruct.endDate = instruction[i].valueForKey(StringUtil.end_date) as! String
            instruct.classNumber = instruction[i].valueForKey(StringUtil.class_number) as! Int
            
            instructions.insert(instruct, atIndex: i)
        }
        
        return instructions
    }
}
