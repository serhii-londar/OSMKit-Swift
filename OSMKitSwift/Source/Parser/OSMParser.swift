//
//  OSMParser.swift
//  Pods
//
//  Created by David Chiles on 12/11/15.
//
//

import Foundation

public protocol OSMParserDelegate {
    func didStartParsing(parser:OSMParser)
    func didFinishParsing(parser:OSMParser)
    func didFindElement(parser:OSMParser,element:OSMElement)
    func didError(parser:OSMParser,error:Error?)
}

public enum XMLName:String {
    case Node     = "node"
    case Way      = "way"
    case Relation = "relation"
    case Tag      = "tag"
    case WayNode  = "nd"
    case Member   = "member"
}

public enum XMLAttributes:String {
    case ID        = "id"
    case UID       = "uid"
    case User      = "user"
    case Version   = "version"
    case Changeset = "changeset"
    case Timestamp = "timestamp"
    case Visible   = "visible"
    case Latitude  = "lat"
    case Longitude = "lon"
    case Key       = "k"
    case Value     = "v"
    case Ref       = "ref"
    case Role      = "role"
    case Typ       = "type"
}

public class OSMParser:NSObject,XMLParserDelegate {
    
    public var delegate:OSMParserDelegate?
    public var delegateQueue = DispatchQueue(label:"OSMParserDelegateQueue")
    
    private var currentOperation:OSMParseOperation?
    private var endOperation = Operation()
    private let operationQueue = OperationQueue()
    private var xmlParser:XMLParser
    
    private let workQueue = DispatchQueue(label: "OSMParserWorkQueue")
    
    init(data:NSData) {
        self.xmlParser = XMLParser(data: data as Data)
    }
    
    init(stream:InputStream) {
        self.xmlParser = XMLParser(stream: stream)
        
    }
    
    public func parse() {
        self.xmlParser.delegate = self
        self.operationQueue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        DispatchQueue.global(qos: .background).async(execute: {[weak self] () -> Void in
            self?.xmlParser.parse()
        })
    }
    
    func foundElement(element:OSMElement) {
        self.delegateQueue.async(execute: {[weak self] () -> Void in
            if self != nil {
                self?.delegate?.didFindElement(parser: self!, element: element)
            }
        })
    }
    
    //MARK: NSXMLParserDelegate Methods
    
    @objc public func parserDidStartDocument(parser: XMLParser) {
        self.workQueue.async() { () -> Void in
            
            self.endOperation.completionBlock = {() -> Void in
                self.delegateQueue.async(execute: { () -> Void in
                    self.delegate?.didFinishParsing(parser: self)
                })
            }
            
            self.delegateQueue.async(execute: { () -> Void in
                self.delegate?.didStartParsing(parser: self)
            })
        }
    }
    
    @objc public func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.workQueue.async() {[weak self] () -> Void in
            
            if let name = XMLName(rawValue: elementName) {
                switch name {
                case .Node: fallthrough
                case .Way: fallthrough
                case .Relation:
                    let operation = OSMParseOperation(completion: { [weak self](element) -> Void in
                        self?.foundElement(element: element)
                    })
                    self?.endOperation.addDependency(operation)
                    self?.currentOperation = operation
                default:
                    break
                }
                self?.currentOperation?.add(name, attributes: attributeDict)
            }
            
        }
        
    }
    
    @objc public func parser(parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.workQueue.async() { () -> Void in
            switch elementName {
            case XMLName.Node.rawValue: fallthrough
            case XMLName.Way.rawValue: fallthrough
            case XMLName.Relation.rawValue:
                if let operation = self.currentOperation {
                    self.operationQueue.addOperation(operation)
                }
                
                self.currentOperation = nil
            default:
                break
            }
        }
    }
    
    @objc public func parserDidEndDocument(parser: XMLParser) {
        self.workQueue.async() { () -> Void in
            self.operationQueue.addOperation(self.endOperation)
        }
    }
    
}
