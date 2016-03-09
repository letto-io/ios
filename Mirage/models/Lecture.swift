//
//  Discipline.swift
//  Mirage
//
//  Created by Siena Idea on 07/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Lecture {
    
    let id, startDate, endDate, classe, code, name, profile: String
    
    init(id: String, startDate: String, endDate: String, classe: String, code: String, name: String, profile: String) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.classe = classe
        self.code = code
        self.name = name
        self.profile = profile
    }
    	
    
    
}
	