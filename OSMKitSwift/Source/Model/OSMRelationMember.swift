//
//  OSMRelationMember.swift
//  Pods
//
//  Created by David Chiles on 12/11/15.
//
//

import Foundation

public enum OSMID {
    case node(Int64)
    case way(Int64)
    case relation(Int64)
    
    init(type:OSMElementType,ref:Int64) {
        switch type {
        case .Node: self = .node(ref)
        case .Way: self = .way(ref)
        case .Relation: self = .relation(ref)
        }
    }
    
    func type() -> OSMElementType {
        switch self {
        case .node(_): return .Node
        case .way(_): return .Way
        case .relation(_): return .Relation
        }
    }
    
    func ref() -> Int64 {
        switch self {
        case .node(let ref): return ref
        case .way(let ref): return ref
        case .relation(let ref): return ref
        }
    }
}

public struct OSMRelationMember {
    public var member:OSMID
    public var role:String?
    
    init(member:OSMID, role:String?) {
        self.member = member
        self.role = role
    }
}
