//
//  Doubt.swift
//  Mirage
//
//  Created by Siena Idea on 27/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Doubt: NSObject {
    
    var id: Int = 0
    var status: Int = 0
    var likes: Int = 0
    var presentationId = Presentation().id
    var contributions: Int = 0
    var text: String = ""
    var createdat: String = ""
    var like: Bool = false
    var anonymous: Bool = false
    var person = Person()
    var understand: Bool = false
    
    static func iterateJSONArray(doubts: NSDictionary, keys: AnyObject) -> Array<Doubt> {
        var doubt = Array<Doubt>()
        
        for i in 0 ..< keys.count {
            let db = Doubt()
            
            let key = keys[i] as AnyObject
            let dbts = doubts.valueForKey(key as! String)!
            
            for _ in 0 ..< keys.count {
                let key = dbts.valueForKey(StringUtil.person)!
                db.person.id = key.valueForKey(StringUtil.id) as! Int
                db.person.name = key.valueForKey(StringUtil.name) as! String
            }
            
            db.id = dbts.valueForKey(StringUtil.id) as! Int
            db.contributions = dbts.valueForKey(StringUtil.contributions) as! Int
            db.likes = dbts.valueForKey(StringUtil.likes) as! Int
            db.status = dbts.valueForKey(StringUtil.status) as! Int
            db.presentationId = dbts.valueForKey(StringUtil.presentationid) as! Int
            db.text = dbts.valueForKey(StringUtil.text) as! String
            db.createdat = dbts.valueForKey(StringUtil.createdat) as! String
            db.anonymous = dbts.valueForKey(StringUtil.anonymous) as! Bool
            db.like = dbts.valueForKey(StringUtil.like) as! Bool
            
            doubt.insert(db, atIndex: i)
        }
        return doubt
    }		
}
