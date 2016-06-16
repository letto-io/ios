//
//  Presentation.swift
//  Mirage
//
//  Created by Siena Idea on 30/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Presentation: NSObject {
    
    var id: Int = 0
    var status: Int = 0
    var createdat: String = ""
    var subject: String = ""
    var person = Person()
    
    
    static func iterateJSONArray(presentations: NSArray, persons: NSArray) -> Array<Presentation> {
        var presentation = Array<Presentation>()
        
        for i in 0 ..< presentations.count {
        
            let present = Presentation()
            
            for _ in 0 ..< persons.count {
                present.person.name = persons[i].valueForKey(StringUtil.name) as! String
            }
            
            present.id = presentations[i].valueForKey(StringUtil.id) as! Int
            present.createdat = presentations[i].valueForKey(StringUtil.createdat) as! String
            present.status = presentations[i].valueForKey(StringUtil.status) as! Int
            present.subject = presentations[i].valueForKey(StringUtil.subject) as! String
            
            presentation.insert(present, atIndex: i)
        }
        
        return presentation
    }
}
