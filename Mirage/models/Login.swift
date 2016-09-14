//
//  Login.swift
//  Mirage
//
//  Created by Oddin on 01/08/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Login {
    
    var id = Int()
    var created_at = String()
    var token = String()
    var person = Person()
    
    static func iterateJSONArray(_ login: NSDictionary, person: NSDictionary) -> Login {
        let lgn = Login()
        
        lgn.created_at = login.value(forKey: StringUtil.created_at) as! String
        lgn.id = login.value(forKey: StringUtil.login_id) as! Int
        lgn.token = login.value(forKey: StringUtil.token) as! String
        lgn.person.id = person.value(forKey: StringUtil.id) as! Int
        lgn.person.email = person.value(forKey: StringUtil.email) as! String
        lgn.person.name = person.value(forKey: StringUtil.name) as! String
        
        return lgn
    }
}
