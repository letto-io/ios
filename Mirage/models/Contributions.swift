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
    var mcmaterial = MCMaterial()
    var person = Person()
    var text: NSArray = []
    
    static func iterateJSONArray(contributions: NSArray, mcmaterials: NSArray, persons: NSArray) -> Array<Contributions> {
        var contribution = Array<Contributions>()
        
        for i in 0 ..< contributions.count {
            let contrib = Contributions()
            
            for _ in 0 ..< persons.count {
                contrib.person.name = persons[i].valueForKey(StringUtil.name) as! String
            }
            
            for _ in 0 ..< mcmaterials.count {
                contrib.mcmaterial.id = mcmaterials[i].valueForKey(StringUtil.id) as! Int
                contrib.mcmaterial.mime = mcmaterials[i].valueForKey(StringUtil.mime) as! String
                contrib.mcmaterial.name = mcmaterials[i].valueForKey(StringUtil.name) as! String
            }
            
            contrib.id = contributions[i].valueForKey(StringUtil.id) as! Int
            contrib.createdat = contributions[i].valueForKey(StringUtil.createdat) as! String
            
            contribution.insert(contrib, atIndex: i)
        }
        return contribution
    }
}
