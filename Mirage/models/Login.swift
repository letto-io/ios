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
    var userId = Int()
    
    static func iterateJSONArray(loginJSONData: NSDictionary) -> Login {
        let login = Login()
        
        login.created_at = loginJSONData.valueForKey(StringUtil.created_at) as! String
        login.id = loginJSONData.valueForKey(StringUtil.login_id) as! Int
        login.token = loginJSONData.valueForKey(StringUtil.token) as! String
        login.userId = loginJSONData.valueForKey(StringUtil.user_id) as! Int
        
        return login
    }
}