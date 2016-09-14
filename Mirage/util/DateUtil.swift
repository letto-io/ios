//
//  DateUtil.swift
//  Mirage
//
//  Created by Siena Idea on 30/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class DateUtil {
    
    static func date(_ date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.string(from: date!)   
        
        return newDate
    }
    
    static func dateAndHour(_ date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.string(from: date!)
        
        return newDate
    }
    
    static func hour(_ date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM - HH:mm"
        let newDate = dateFormatter.string(from: date!)
        
        return newDate
    }
}
