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
    //static let url = "http://ws-oddin.herokuapp.com"
    
    static let session = "/session/"
    static let instructions = "/instructions/"
    static let presentations = "/presentations/"
    static let questions = "/questions/"
    static let answers = "/answers"
    static let answer = "/answer"
    static let materials = "/materials/"
    static let profile = "/profile"
    static let person = "/person"
    static let close = "/close"
    static let upvote = "/upvote"
    static let recoverpassword = "/recover-password"
    
    
    
    
    
    static let presentaion = "/presentation"
    static let presentaion_bar = "/presentation/"
    static let contribution_bar = "/contribution/"
    static let materials_bar = "/materials/"
    
    static let doubt = "/doubt"
    static let doubt_bar = "/doubt/"
    static let like = "/like"
    static let contribution = "/contribution"
    
    static var token = String()
    
    static func getRequestNew(_ url: String) -> URLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let url = url
        
        request.url = URL(string: url)
        
        request.httpMethod = StringUtil.httpGET
        request.addValue(Server.token, forHTTPHeaderField: StringUtil.sessionToken)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        return request as URLRequest
    }
    
    static func getRequestDownloadMaterial(_ url: String) -> URLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        request.url = URL(string: urlPath)
        
        request.httpMethod = StringUtil.httpGET
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        return request as URLRequest
    }
    
    static func postRequestParseJSONSendToken(_ url: String, _ JSONObject: AnyObject) -> URLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let url = url
        
        request.url = URL(string: url)
        request.httpMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue(Server.token, forHTTPHeaderField: StringUtil.sessionToken)
        request.setValue(StringUtil.httpApplication, forHTTPHeaderField: StringUtil.httpHeader)
        request.httpBody = try! JSONSerialization.data(withJSONObject: JSONObject, options:  JSONSerialization.WritingOptions(rawValue:0))
        
        return request as URLRequest
    }
    
    static func postRequestParseJSON(_ url: String, _ JSONObject: AnyObject) -> URLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let url = url
        
        request.url = URL(string: url)
        request.httpMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.setValue(StringUtil.httpApplication, forHTTPHeaderField: StringUtil.httpHeader)
        request.httpBody = try! JSONSerialization.data(withJSONObject: JSONObject, options:  JSONSerialization.WritingOptions(rawValue:0))
        
        return request as URLRequest
    }
    
    static func postRequestSendToken(_ url: String) -> URLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let url = url
        
        request.url = URL(string: url)
        request.httpMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue(Server.token, forHTTPHeaderField: StringUtil.sessionToken)
        
        return request as URLRequest
    }
    
    static func deleteRequest(_ url: String) -> URLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.url = URL(string: urlPath)
        request.httpMethod = StringUtil.httpDELETE
        request.addValue(Server.token, forHTTPHeaderField: StringUtil.sessionToken)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        return request as URLRequest
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    
    static func getRequest(_ url: String) -> URL {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        let url = URL(string: urlPath)!
        
        let cookieHeaderField = [StringUtil.set_Cookie : StringUtil.key_Value]
        
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
        
        request.httpMethod = StringUtil.httpGET
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        return url
    }
    
    static func postResquestNotSendCookie(_ url: String) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.url = URL(string: urlPath)
        request.httpMethod = StringUtil.httpPOST
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        return request
    }
    
    
//    static func uploadRequestImagePNG(url: String, fname: String, image: UIImage) -> NSMutableURLRequest{
//        let request: NSMutableURLRequest = NSMutableURLRequest()
//        let urlPath = url
//        
//        request.URL = NSURL(string: urlPath)
//        let image_data = UIImagePNGRepresentation(image)
//        
//        let fname = fname
//        let mimetype = "image/png"
//        
//        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
//        let contentType = "multipart/form-data; boundary=\(boundary)"
//        request.HTTPMethod = "POST"
//        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        let body = NSMutableData()
//        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(image_data!)
//        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        request.HTTPBody = body
//        
//        return request
//    }
    
    static func uploadRequestVideoMP4(_ url: String, _ fname: String, _ videoData: Data) -> NSMutableURLRequest{
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.url = URL(string: urlPath)
        let video_data = videoData
        
        let fname = fname
        let mimetype = "video/mp4"
        
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(video_data)
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        request.httpBody = body as Data
        
        return request
    }
    
//    static func uploadRequestVideoMP4FromGalery(url: String, fname: String, image: UIImage) -> NSMutableURLRequest{
//        let request: NSMutableURLRequest = NSMutableURLRequest()
//        let urlPath = url
//        
//        request.URL = NSURL(string: urlPath)
//        let video_data = UIImagePNGRepresentation(image)
//        
//        let fname = fname
//        let mimetype = "video/mp4"
//        
//        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
//        let contentType = "multipart/form-data; boundary=\(boundary)"
//        request.HTTPMethod = "POST"
//        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        let body = NSMutableData()
//        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(video_data!)
//        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        request.HTTPBody = body
//        
//        return request
//    }
    
    static func uploadRequestAudiom4a(_ url: String, _ fname: String, _ audioRecorder: Data) -> NSMutableURLRequest{
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = url
        
        request.url = URL(string: urlPath)
        let audio = audioRecorder
        
        let fname = fname
        let mimetype = "audio/3gpp"
        
        let boundary:String = "------WebKitFormBoundaryasdas543wfsdfs5453533d3sdfsf3"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fname)\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Type: \(mimetype)\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(audio)
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        request.httpBody = body as Data
        
        return request
    }
    
}
