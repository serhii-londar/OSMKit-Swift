//
//  File.swift
//  OSMKit
//
//  Created by David Chiles on 12/17/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import Foundation

var onceToken: Int = 0
var instance: DateFormatter? = nil

public extension DateFormatter {
    // 2x speed increate using singlton from onceToken vs creating a new nsdateformatter each time it's used
    public class func defaultOpenStreetMapDateFormatter() -> DateFormatter{
//        dispatch_once(&onceToken) {
            instance = DateFormatter()
            instance?.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
//        }
        return instance!
    }
    
}
