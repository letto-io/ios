//
//  Server.swift
//  Mirage
//
//  Created by Siena Idea on 07/03/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import Foundation

class Server {
    
    static let url = "http://ws-edupanel.herokuapp.com"
    
    static let session = "/session"
    static let instructions = "/instructions/"
    static let presentations = "/presentations/"
    static let questions = "/questions"
    static let profile = "/profile"
    static let person = "/person"
    
    
    
    static let presentaion = "/presentation"
    static let presentaion_bar = "/presentation/"
    static let contribution_bar = "/contribution/"
    static let materials_bar = "/materials/"
    static let close = "/close"
    static let doubt = "/doubt"
    static let doubt_bar = "/doubt/"
    static let like = "/like"
    static let contribution = "/contribution"
    
    
    static let recoverPasswordURL = "http://ws-edupanel.herokuapp.com/controller/recover-password"
    static let disciplineURL = "http://rws-edupanel.herokuapp.com/instructions"
    static let presentationURL = "http://rws-edupanel.herokuapp.com/presentations/"
    
    static var token = String()
    
    static func getRequestNew(url: String) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        request.URL = NSURL(string: urlPath)
        
        request.HTTPMethod = StringUtil.httpGET
        request.addValue(Server.token, forHTTPHeaderField: StringUtil.sessionToken)
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        return request
    }
    
    static func postRequestParseJSONSendToken(url: String, JSONObject: AnyObject) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let url = url
        
        request.URL = NSURL(string: url)
        request.HTTPMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.addValue(Server.token, forHTTPHeaderField: StringUtil.sessionToken)
        request.setValue(StringUtil.httpApplication, forHTTPHeaderField: StringUtil.httpHeader)
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options:  NSJSONWritingOptions(rawValue:0))
        
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
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    
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
    
    
    
    static func deleteRequest(url: String) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.URL = NSURL(string: urlPath)
        request.HTTPMethod = StringUtil.httpDELETE
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        return request
    }
    
    static func uploadRequestImagePNG(url: String, fname: String, image: UIImage) -> NSMutableURLRequest{
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.URL = NSURL(string: urlPath)
        let image_data = UIImagePNGRepresentation(image)
        
        let fname = fname
        let mimetype = "image/png"
        
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.HTTPMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image_data!)
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        return request
    }
    
    static func uploadRequestVideoMP4(url: String, fname: String, videoData: NSData) -> NSMutableURLRequest{
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.URL = NSURL(string: urlPath)
        let video_data = videoData
        
        let fname = fname
        let mimetype = "video/mp4"
        
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.HTTPMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(video_data)
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        return request
    }
    
    static func uploadRequestVideoMP4FromGalery(url: String, fname: String, image: UIImage) -> NSMutableURLRequest{
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.URL = NSURL(string: urlPath)
        let video_data = UIImagePNGRepresentation(image)
        
        let fname = fname
        let mimetype = "video/mp4"
        
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.HTTPMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(video_data!)
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        return request
    }
    
    static func uploadRequestAudiom4a(url: String, fname: String, audioRecorder: NSData) -> NSMutableURLRequest{
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.URL = NSURL(string: urlPath)
        let audio = audioRecorder
        
        let fname = fname
        let mimetype = "audio/3gpp"
        
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.HTTPMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(audio)
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        return request
    }
    
}
