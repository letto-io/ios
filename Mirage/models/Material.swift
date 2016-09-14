//
//  MCMaterial.swift
//  Mirage
//
//  Created by Oddin on 08/06/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Material: NSObject {
    
    var id = Int()
    var attachable_id = Int()
    var attachable_type = String()
    var checked = Bool()
    var mime = String()
    var name = String()
    var person = Person()
    var uploaded_at = String()
    
    static func iterateJSONArray(_ material: NSArray, person: NSArray) -> Array<Material> {
        var materials = Array<Material>()
        
        for i in 0 ..< material.count {
            let mtrl = Material()
            
            mtrl.attachable_id = (material[i] as AnyObject).value(forKey: StringUtil.attachable_id) as! Int
            mtrl.attachable_type = (material[i] as AnyObject).value(forKey: StringUtil.attachable_type) as! String
            mtrl.checked = (material[i] as AnyObject).value(forKey: StringUtil.checked) as! Bool
            mtrl.id = (material[i] as AnyObject).value(forKey: StringUtil.id) as! Int
            mtrl.mime = (material[i] as AnyObject).value(forKey: StringUtil.mime) as! String
            mtrl.name = (material[i] as AnyObject).value(forKey: StringUtil.name) as! String
            mtrl.uploaded_at = (material[i] as AnyObject).value(forKey: StringUtil.uploaded_at) as! String
            
            for _ in 0 ..< person.count {
                mtrl.person.id = (person[i] as AnyObject).value(forKey: StringUtil.id) as! Int
                mtrl.person.name = (person[i] as AnyObject).value(forKey: StringUtil.name) as! String
                mtrl.person.email = (person[i] as AnyObject).value(forKey: StringUtil.email) as! String
            }
            
            materials.insert(mtrl, at: i)
        }
        
        return materials
    }
}
