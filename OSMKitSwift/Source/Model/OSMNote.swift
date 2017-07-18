//
//  OSMNote.swift
//  Pods
//
//  Created by David Chiles on 1/5/16.
//
//

import Foundation
import CoreLocation

public struct OSMComment {
    public var userId:Int64?
    public var username:String?
    public var dateString:String
    public var text:String?
    public var action:OSMCommentAction
    
    public init(dateString:String, action:OSMCommentAction) {
        self.dateString = dateString
        self.action = action
    }
}

open class OSMNote: OSMIdentifiable {
    open var osmIdentifier:Int64 = -1
    
    /** This node latitude. (WGS 84 - SRID 4326) */
    open var latitude:CLLocationDegrees = 0
    
    /** This node longitude. (WGS 84 - SRID 4326) */
    open var longitude:CLLocationDegrees = 0;
    
    open var open = true
    
    open var url:URL? = nil
    
    open var comments:[OSMComment]?
    
    open var dateCreated:String
    open var dateClosed:String?
    
    public init(osmIdentifier:Int64, latitude:CLLocationDegrees, longitude:CLLocationDegrees, open:Bool, dateCreated:String, dateClosed:String?, url:URL?) {
        self.osmIdentifier = osmIdentifier
        self.latitude = latitude
        self.longitude = longitude
        self.open = open
        self.dateCreated = dateCreated
        self.dateClosed = dateClosed
        self.url = url
    }
}
