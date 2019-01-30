//
//  RequestEditAttendance.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/29/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import Foundation

enum RequestAttendanceType: String {
    case none = "RC_NONE"
    case overtime = "RC_OVERTIME"
    case research = "RC_RESEARCH"
    case dayOff = "RC_DAYOFF"
    case watch = "RC_WATCH"
    case dayoffWorking = "RC_DAYOFF_WORKING"
    
    var content: String {
        switch self {
        case .none:
            return ""
        case .overtime:
            return "overtime"
        case .research:
            return "research"
        case .dayOff:
            return "dayyOff"
        case .watch:
            return "watch"
        case .dayoffWorking:
            return "day off"
        }
    }
}

enum RequestAttendanceStatus: String {
    case none = "RS_NONE"
    case new = "RS_NEW"
    case accepted = "RS_ACCEPTED"
    case rejected = "RS_REJECTED"
    
    var content: String {
        switch self {
        case .none:
            return "none"
        case .new:
            return "new"
        case .accepted:
            return "accepted"
        case .rejected:
            return "rejected"
        }
    }
}

class RequestEditAttendance {
    var id: String?
    
    var startTime: String?
    
    var endTime: String?
    
    var reasonId: String?
    
    var reasonCategories: RequestAttendanceType?
    
    var requestStatus: RequestAttendanceStatus?
    
    var comment: String?
    
    // TODO: Change to attachment
    var attachmentList: [String]?
    
    init(dict: NSDictionary) {
        self.id = dict["id"] as? String
        self.startTime = dict["startTime"] as? String
        self.endTime = dict["endTime"] as? String
        self.reasonId = dict["reasonId"] as? String
        if let reasonCategories = dict["reasonCategories"] as? String {
            self.reasonCategories = RequestAttendanceType(rawValue: reasonCategories)
        }
        if let requestStatus = dict["requestStatus"] as? String {
            self.requestStatus = RequestAttendanceStatus(rawValue: requestStatus)
        }
        self.comment = dict["comment"] as? String
        self.attachmentList = dict["attachmentList"] as? [String]
    }
    
    init() {
        
    }
    
    static func createDummyData() -> [RequestEditAttendance] {
        var results: [RequestEditAttendance] = []
        
        let requestOne = RequestEditAttendance()
        requestOne.startTime = "07:00"
        requestOne.endTime = "08:00"
        requestOne.reasonCategories = RequestAttendanceType(rawValue: "RC_OVERTIME")
        requestOne.requestStatus = RequestAttendanceStatus(rawValue: "RS_NEW")
        results.append(requestOne)
        
        let requestTwo = RequestEditAttendance()
        requestTwo.startTime = "08:00"
        requestTwo.endTime = "09:00"
        requestTwo.reasonCategories = RequestAttendanceType(rawValue: "RC_OVERTIME")
        requestTwo.requestStatus = RequestAttendanceStatus(rawValue: "RS_NEW")
        results.append(requestTwo)
        
        let requestThree = RequestEditAttendance()
        requestThree.startTime = "09:00"
        requestThree.endTime = "10:00"
        requestThree.reasonCategories = RequestAttendanceType(rawValue: "RC_OVERTIME")
        requestThree.requestStatus = RequestAttendanceStatus(rawValue: "RS_NEW")
        results.append(requestThree)
        
        return results
    }
}
