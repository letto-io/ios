//
//  DateUtil.swift
//  Mirage
//
//  Created by Siena Idea on 30/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class DateUtil {
    
    static func date(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.stringFromDate(date!)
        
        return newDate
    }
    
    static func date1(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.stringFromDate(date!)
        
        return newDate
    }
    
    static func hour(date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let newDate = dateFormatter.stringFromDate(date!)
        
        return newDate
    }
}