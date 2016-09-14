//
//  Person.swift
//  Mirage
//
//  Created by Siena Idea on 30/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Person: NSObject {
    
    var id = Int()
    var name = String()
    var email = String()
    var profile = Int()
    
    static func parsePersonJSON(_ person: NSDictionary) -> Person {
        let prsn = Person()
        
        prsn.id = person.value(forKey: StringUtil.id) as! Int
        prsn.name = person.value(forKey: StringUtil.name) as! String
        prsn.email = person.value(forKey: StringUtil.email) as! String
        
        return prsn
    }
    
    static func parseUserProfileJSON(_ profile: NSDictionary, person: NSObject) -> Person {
        let prsn = Person()
        
        prsn.id = person.value(forKey: StringUtil.id) as! Int
        prsn.name = person.value(forKey: StringUtil.name) as! String
        prsn.profile = profile.value(forKey: StringUtil.profile) as! Int
        
        return prsn
    }
    
}
