//
//  Discipline.swift
//  Mirage
//
//  Created by Siena Idea on 07/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Discipline: NSObject {
    
    var id: Int = 0
    var code: String = ""
    var startDate: String = ""
    var classe: Int = 0
    var endDate: String = ""
    var profile: Int = 0
    var name: String = ""
    var event = Event()
    
    
    static func iterateJSONArray(disciplines: NSArray, events: NSArray) -> Array<Discipline> {
        var discipline = Array<Discipline>()
        
        for i in 0 ..< disciplines.count {
            let disc = Discipline()
            
            for _ in 0 ..< events.count {
                disc.event.name = events[i].valueForKey(StringUtil.name) as! String
                disc.event.code = events[i].valueForKey(StringUtil.code) as! String
            }
            
            disc.id = disciplines[i].valueForKey(StringUtil.id) as! Int
            disc.code = disciplines[i].valueForKey(StringUtil.code) as! String
            disc.startDate = disciplines[i].valueForKey(StringUtil.startdate) as! String
            disc.classe = disciplines[i].valueForKey(StringUtil.classe) as! Int
            disc.endDate = disciplines[i].valueForKey(StringUtil.enddate) as! String
            disc.profile = disciplines[i].valueForKey(StringUtil.profile) as! Int
            disc.name = disciplines[i].valueForKey(StringUtil.name) as! String
            
            discipline.insert(disc, atIndex: i)
        }
        
        return discipline 
    }
    
//    init(id: Int, code: String, startDate: String, classe: Int, endDate: String, profile: Int, name: String, event: Event) {
//        self.id = id
//        self.startDate = startDate
//        self.classe = classe
//        self.endDate = endDate
//        self.profile = profile
//        self.name = name
//        self.event = event
//    }
}
	