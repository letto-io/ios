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
}
