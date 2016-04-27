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
    var stattus: String = ""
    var text: String = ""
    var createAt: String = ""
    var anonymous: String = ""
    var presentationId = Presentation().id
    var personId = Person().id
    var personName = Person().name
    
}
