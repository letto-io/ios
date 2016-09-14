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
    var class_number = Int()
    var start_date = String()
    var end_date = String()
    var profile = Int()
    var event = Event()
    var lecture = Lecture()
    
    static func iterateJSONArray(_ instruction: NSArray, lecture: NSArray, event: NSArray) -> Array<Instruction> {
        var instructions = Array<Instruction>()
        
        for i in 0 ..< instruction.count {
            let instruct = Instruction()
            
            for _ in 0 ..< event.count {
                instruct.event.id = (event[i] as AnyObject).value(forKey: StringUtil.id) as! Int
                instruct.event.code = (event[i] as AnyObject).value(forKey: StringUtil.code) as! String
                instruct.event.name = (event[i] as AnyObject).value(forKey: StringUtil.name) as! String
                instruct.event.workload = (event[i] as AnyObject).value(forKey: StringUtil.workload) as! String
                
            }
            
            for _ in 0 ..< lecture.count {
                instruct.lecture.id = (lecture[i] as AnyObject).value(forKey: StringUtil.id) as! Int
                instruct.lecture.code = (lecture[i] as AnyObject).value(forKey: StringUtil.code) as! String
                instruct.lecture.name = (lecture[i] as AnyObject).value(forKey: StringUtil.name) as! String
                instruct.lecture.workload = (lecture[i] as AnyObject).value(forKey: StringUtil.workload) as! String
            }
            
            instruct.id = (instruction[i] as AnyObject).value(forKey: StringUtil.id) as! Int
            instruct.start_date = (instruction[i] as AnyObject).value(forKey: StringUtil.start_date) as! String
            instruct.end_date = (instruction[i] as AnyObject).value(forKey: StringUtil.end_date) as! String
            instruct.class_number = (instruction[i] as AnyObject).value(forKey: StringUtil.class_number) as! Int
            instruct.profile = (instruction[i] as AnyObject).value(forKey: StringUtil.profile) as! Int
            
            instructions.insert(instruct, at: i)
        }
        
        return instructions
    }
}
