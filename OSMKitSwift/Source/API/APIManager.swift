//
//  APIManager.swift
//  
//
//  Created by David Chiles on 12/21/15.
//
//

import Foundation
import Alamofire

public enum APIURLString:String {
    case Public = "https://api.openstreetmap.org/api/0.6/"
    case Dev = "http://api06.dev.openstreetmap.org/api/0.6/"
    
    func endpoint(_ endpoint:APIEndpoint) -> String {
        return self.rawValue + endpoint.rawValue
    }
}

enum APIEndpoint:String {
    case Map = "map"
    case Notes = "notes.json"
    
}

internal enum Paramters:String {
    case BoundingBox = "bbox"
}

extension BoundingBox {
    func osmURLString() -> String {
        return "\(self.left),\(self.bottom),\(self.right),\(self.top)"
    }
}

open class OSMAPIManager: SessionDelegate {
    
    open var URL:APIURLString = .Public
    
    open var apiManager: SessionManager! = nil
    
    init(apiConsumerKey:String,apiPrivateKey:String,token:String,tokenSecret:String,configuration:URLSessionConfiguration = URLSessionConfiguration.default) {
        super.init()
        self.apiManager = SessionManager(configuration: configuration, delegate: self, serverTrustPolicyManager: nil)
    }
    
    
    //MARK: Downling data
    open func downloadBoundingBox(_ boundingBox:BoundingBox,completion:@escaping (_ data:NSData?,_ error:Error?)->Void) {
        let bboxString = boundingBox.osmURLString()
        let parameters = [Paramters.BoundingBox.rawValue:bboxString]
        let urlString = self.URL.endpoint(.Map)
        self.apiManager.request(urlString, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            completion(response.data as NSData?, response.error)
        }
        
        
        //request(.GET, urlString, parameters: parameters, encoding: .URL, headers: nil).response { (request, response, data, error) -> Void in
//
    }
    
    //Mark: Downloading Notes
    open func downloadNotesBoundingBox(_ boundingBox:BoundingBox, completion:@escaping (_ data:NSData?, _ error:Error?)->Void) {
        let bboxString = boundingBox.osmURLString()
        let parameters = [Paramters.BoundingBox.rawValue:bboxString]
        let urlString = self.URL.endpoint(.Notes)
        self.apiManager.request(urlString, parameters: parameters, encoding: URLEncoding.default).responseData(completionHandler: { (response) in
            completion(response.data as NSData?, response.error)
        })
    }
    
    //Mark Uploading Data
    
    open func openChangeset(_ tags:[String:String],completion:()->Void) {
        
    }
}
