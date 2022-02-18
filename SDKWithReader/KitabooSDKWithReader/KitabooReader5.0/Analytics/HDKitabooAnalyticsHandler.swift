//
//  HDKitabooAnalyticsHandler.swift
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 02/02/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit

@objc open class HDKitabooAnalyticsMetaData:NSObject {
    fileprivate var cfi:String?
    fileprivate var pageId:String?
    fileprivate var timeSpent:String?
    fileprivate var chapterId:String?
    fileprivate var chapterName:String?
    fileprivate var uniqueId:String?
    fileprivate var bookId:String?
    fileprivate var openTimeStamp:String?
    fileprivate var classId:String?
    fileprivate var accessTime:String?
    fileprivate var lastPageFolio:String?
    fileprivate var suspendData:String?
    fileprivate var resourceDict:Dictionary<String, Any>?
    
    @objc public init(withPageTracking cfi:String?, pageId:String?, timeSpent:String?, chapterId:String?, chapterName:String?, uniqueId:String?) {
        super.init()
        self.cfi = cfi
        self.pageId = pageId
        self.timeSpent = timeSpent
        self.chapterId = chapterId
        self.chapterName = chapterName
        self.uniqueId = uniqueId
    }
    
    @objc public init(withBookOpen bookId:String?, openTimeStamp:String?, classId:String?, suspendData:String?, uniqueId:String?) {
        super.init()
        self.bookId = bookId
        self.openTimeStamp = openTimeStamp
        self.classId = classId
        self.suspendData = suspendData
        self.uniqueId = uniqueId
    }
    
    @objc public init(withBookClose accessTime:String?, lastPageFolio:String?, uniqueId:String?) {
        super.init()
        self.accessTime = accessTime
        self.lastPageFolio = lastPageFolio
        self.uniqueId = uniqueId
    }
    
    @objc public init(withUGCTracking pageId:String?, uniqueId:String?) {
        super.init()
        self.pageId = pageId
        self.uniqueId = uniqueId
    }
    
    @objc public init(withResourceTracking resourceDict:Dictionary<String, Any>?, uniqueId:String?) {
        super.init()
        self.resourceDict = resourceDict
        self.uniqueId = uniqueId
    }
}

@objc open class HDKitabooAnalyticsHandler: NSObject {
    @objc public enum HDAnalyticsEventType : Int{
        case kTypePageTracking = 0,
             kTypeNoteCreated,
             kTypeImpHighlightCreated,
             kTypeNormHighlightCreated,
             kTypeNoteShared,
             kTypeNoteReceived,
             kTypeNoteDeleted,
             kTypeImpHighlightDeleted,
             kTypeNormHighlightDeleted,
             kTypeBookClose,
             kTypeBookOpen,
             kTypeImpHighlightReceived,
             kTypeNormHighlightReceived,
             kTypeImpHighlightShared,
             kTypeNormHighlightShared,
             kTypeLinkOpen
    }
    private let bookIdString = "bookID"
    private let openTimeStampString = "bookOpenTimeStamp"
    private let classIdString = "classID"
    private let suspendDataString = "suspendData"
    private let cfiString = "cfID"
    private let pageIdString = "pageID"
    private let chapterIdString = "chapterID"
    private let chapterNameString = "chapterName"
    private let timespendString = "TimeSpend"
    private let accessTimeString = "AccessTime"
    private let lastPageFolioString = "LastPageFolio"
    private let sessionIdString = "ReaderSeatingID"
    private var readerSessionId:String!
    @objc public override init() {
        super.init()
        readerSessionId = UUID().uuidString
    }
    @objc open func trackEvent(_ eventType:HDAnalyticsEventType, metadata:HDKitabooAnalyticsMetaData) {
        var trackingDict:Dictionary<String, Any> = [:]
        switch eventType {
        case HDAnalyticsEventType.kTypeBookOpen:
            if let bookId = metadata.bookId {
                trackingDict[bookIdString] = bookId
            }
            if let openTimeStamp = metadata.openTimeStamp {
                trackingDict[openTimeStampString] = openTimeStamp
            }
            if let classId = metadata.classId {
                trackingDict[classIdString] = classId
            }
            if let suspendData = metadata.suspendData {
                trackingDict[suspendDataString] = suspendData
            } else {
                trackingDict[suspendDataString] = "0"
            }
            break
        case HDAnalyticsEventType.kTypePageTracking:
            if let cfiStr = metadata.cfi {
                trackingDict[cfiString] = cfiStr
            }
            if let pageId = metadata.pageId {
                trackingDict[pageIdString] = pageId
            }
            if let chapterId = metadata.chapterId {
                trackingDict[chapterIdString] = chapterId
            }
            if let chapterName = metadata.chapterName {
                trackingDict[chapterNameString] = chapterName
            }
            if let timeSpent = metadata.timeSpent {
                trackingDict[timespendString] = timeSpent
            }
            break
        case HDAnalyticsEventType.kTypeBookClose:
            if let accessTime = metadata.accessTime {
                trackingDict[accessTimeString] = accessTime
            }
            if let lastPageFolio = metadata.lastPageFolio {
                trackingDict[lastPageFolioString] = lastPageFolio
            }
            break
        case HDAnalyticsEventType.kTypeNoteCreated, HDAnalyticsEventType.kTypeNoteDeleted,HDAnalyticsEventType.kTypeNoteReceived,HDAnalyticsEventType.kTypeImpHighlightCreated,HDAnalyticsEventType.kTypeImpHighlightDeleted,HDAnalyticsEventType.kTypeNormHighlightCreated,HDAnalyticsEventType.kTypeNormHighlightDeleted,HDAnalyticsEventType.kTypeNoteShared,HDAnalyticsEventType.kTypeNormHighlightReceived,HDAnalyticsEventType.kTypeImpHighlightReceived,HDAnalyticsEventType.kTypeNormHighlightShared,HDAnalyticsEventType.kTypeImpHighlightShared:
            if let pageId = metadata.pageId {
                trackingDict[pageIdString] = pageId
            }
            break
        case HDAnalyticsEventType.kTypeLinkOpen:
            if let resourceDictionary = metadata.resourceDict {
                trackingDict = resourceDictionary
            }
        break
        default:
            break
            
        }
        if (readerSessionId != nil) {
            trackingDict[sessionIdString] = readerSessionId
        }
        var uniqueIdString:String = UUID().uuidString
        if let uniqueId = metadata.uniqueId {
            uniqueIdString = uniqueId
        }
        AnalyticsManager.getInstance()?.trackEvent(analyticsEventNameForType(eventType), withEventInfo: trackingDict, wihUniqueID: uniqueIdString)
    }
    
    func analyticsEventNameForType(_ type:HDAnalyticsEventType) -> String {
        switch (type) {
        case HDAnalyticsEventType.kTypeNoteCreated:
            return "NoteCreated";
        case HDAnalyticsEventType.kTypeNoteDeleted:
            return "NoteDeleted";
        case HDAnalyticsEventType.kTypeNoteReceived:
            return "NoteReceived";
        case HDAnalyticsEventType.kTypeImpHighlightCreated:
            return "ImpHighlightCreated";
        case HDAnalyticsEventType.kTypeImpHighlightDeleted:
            return "ImpHighlightDeleted";
        case HDAnalyticsEventType.kTypeNormHighlightCreated:
            return "NormHighlightCreated";
        case HDAnalyticsEventType.kTypeNormHighlightDeleted:
            return "NormHighlightDeleted";
        case HDAnalyticsEventType.kTypePageTracking:
            return "PageTracking";
        case HDAnalyticsEventType.kTypeBookOpen:
            return "BookOpen";
        case HDAnalyticsEventType.kTypeBookClose:
            return "BookClose";
        case HDAnalyticsEventType.kTypeLinkOpen:
            return "LinkOpen";
        case HDAnalyticsEventType.kTypeNoteShared:
            return "NoteShared";
        case HDAnalyticsEventType.kTypeNormHighlightReceived:
            return "NormHighlightReceived";
        case HDAnalyticsEventType.kTypeImpHighlightReceived:
            return "ImpHighlightReceived";
        case HDAnalyticsEventType.kTypeNormHighlightShared:
            return "NormalHighlightShared";
        case HDAnalyticsEventType.kTypeImpHighlightShared:
            return "ImpHighlightShared";
        default:
            break;
        }
        return "";
    }
    
    @objc open func notifyEvent(_ eventName:String!, eventInfo:Dictionary<String, Any>!) {
        AnalyticsManager.getInstance()?.notifyEvent(eventName, withEventInfo: eventInfo)
    }
    
    @objc open func getTrackingJSON()->String {
        let trackingJson = AnalyticsManager.getInstance()?.getTrackingJSON()
        return trackingJson!;
    }
}
