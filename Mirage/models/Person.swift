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
    var user = User()
    var profile = Int()
    
    static func parsePersonJSON(person: NSDictionary, user: NSObject) -> Person {
        let prsn = Person()
        
        prsn.id = person.valueForKey(StringUtil.id) as! Int
        prsn.name = person.valueForKey(StringUtil.name) as! String
        prsn.user.id = user.valueForKey(StringUtil.id) as! Int
        prsn.user.email = user.valueForKey(StringUtil.email) as! String
        
        return prsn
    }
    
    static func parseUserProfileJSON(profile: NSDictionary, person: NSObject) -> Person {
        let prsn = Person()
        
        prsn.id = person.valueForKey(StringUtil.id) as! Int
        prsn.name = person.valueForKey(StringUtil.name) as! String
        prsn.profile = profile.valueForKey(StringUtil.profile) as! Int
        
        return prsn
    }
    
}
