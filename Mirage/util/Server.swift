//
//  Server.swift
//  Mirage
//
//  Created by Siena Idea on 07/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Server {
    
    static let presentaion = "/presentation"
    static let presentaion_bar = "/presentation/"
    static let contribution_bar = "/contribution/"
    static let materials_bar = "/materials/"
    static let close = "/close"
    static let doubt = "/doubt"
    static let doubt_bar = "/doubt/"
    static let like = "/like"
    static let contribution = "/contribution"
    
    
    static let loginURL = "http://ws-edupanel.herokuapp.com/controller/login"
    static let recoverPasswordURL = "http://ws-edupanel.herokuapp.com/controller/recover-password"
    static let disciplineURL = "http://ws-edupanel.herokuapp.com/controller/instruction"
    static let presentationURL = "http://ws-edupanel.herokuapp.com/controller/instruction/"
    
    
    static func getRequest(url: String) -> NSURL {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        let url = NSURL(string: urlPath)!
        
        let cookieHeaderField = [StringUtil.set_Cookie : StringUtil.key_Value]
        
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: url, mainDocumentURL: nil)
        
        request.HTTPMethod = StringUtil.httpGET
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        return url
    }
    
    static func postResquestNotSendCookie(url: String) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.URL = NSURL(string: urlPath)
        request.HTTPMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        return request
    }
    
    static func postRequestParseJSON(url: String, JSONObject: AnyObject) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let url = url
    
        request.URL = NSURL(string: url)
        request.HTTPMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.setValue(StringUtil.httpApplication, forHTTPHeaderField: StringUtil.httpHeader)
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options:  NSJSONWritingOptions(rawValue:0))
        
        return request
    }
    
    static func deleteRequest(url: String) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.URL = NSURL(string: urlPath)
        request.HTTPMethod = StringUtil.httpDELETE
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        return request
    }
    
}
