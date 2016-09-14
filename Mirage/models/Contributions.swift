//
//  Contributions.swift
//  Mirage
//
//  Created by Oddin on 08/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Contributions: NSObject {
    
    var id: Int = 0
    var createdat: String = ""
    var person = Person()
    var text: NSArray = []
    
    static func iterateJSONArray(_ contributions: NSArray, mcmaterials: NSArray, persons: NSArray) -> Array<Contributions> {
        var contribution = Array<Contributions>()
        
        for i in 0 ..< contributions.count {
            let contrib = Contributions()
            
            for _ in 0 ..< persons.count {
                contrib.person.name = (persons[i] as AnyObject).value(forKey: StringUtil.name) as! String
            }
            
            for _ in 0 ..< mcmaterials.count {
                
            }
            
            contrib.id = (contributions[i] as AnyObject).value(forKey: StringUtil.id) as! Int
            contrib.createdat = (contributions[i] as AnyObject).value(forKey: StringUtil.createdat) as! String
            
            contribution.insert(contrib, at: i)
        }
        return contribution
    }
}
