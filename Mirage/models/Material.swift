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
    var key = String()
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
    
    static func iterateJSONArray(_ answer: NSArray) -> Array<Material> {
        var materials = Array<Material>()
        let material = answer.value(forKey: StringUtil.materials) as! NSArray
        
        for i in 0 ..< material.count {
            let mtrl = Material()
            let key = material[i] as? NSArray
            
            if let keys = key {
                for i in 0 ..< keys.count {
                    if (keys[i] as AnyObject).value(forKey: StringUtil.mime) is NSNull   {
                        print("vazio")
                    } else {
                        mtrl.id = (keys[i] as AnyObject).value(forKey: StringUtil.id) as! Int
                        mtrl.attachable_id = (keys[i] as AnyObject).value(forKey: StringUtil.attachable_id) as! Int
                        mtrl.attachable_type = (keys[i] as AnyObject).value(forKey: StringUtil.attachable_type) as! String
                        mtrl.checked = (keys[i] as AnyObject).value(forKey: StringUtil.checked) as! Bool
                        mtrl.key = (keys[i] as AnyObject).value(forKey: StringUtil.key) as! String
                        mtrl.mime = (keys[i] as AnyObject).value(forKey: StringUtil.mime) as! String
                        mtrl.name = (keys[i] as AnyObject).value(forKey: StringUtil.name) as! String
                        mtrl.uploaded_at = (keys[i] as AnyObject).value(forKey: StringUtil.uploaded_at) as! String
                    }
                    materials.insert(mtrl, at: i)
                }
                    
            } else {
                return materials
            }
        }
        return materials
    }
}
