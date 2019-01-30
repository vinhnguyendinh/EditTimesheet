//
//  HistoryCheckingLog.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/29/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import Foundation

enum LogType: String {
    case checkIn = "CHECK_IN"
    case checkOut = "CHECK_OUT"
}

class HistoryCheckingLog {
    var id: String?
    
    var logType: LogType?
    
    var logTime: String?
    
    var comment: String?
    
    var editorFirstName: String?
    
    var editorLastName: String?
    
    var lastUpdatedAt: String?
    
    init(dict: NSDictionary) {
        self.id = dict["id"] as? String
        if let logType = dict["logType"] as? String {
            self.logType = LogType(rawValue: logType)
        }
        self.comment = dict["comment"] as? String
        self.editorFirstName = dict["editorFirstName"] as? String
        self.editorLastName = dict["editorLastName"] as? String
        self.lastUpdatedAt = dict["lastUpdatedAt"] as? String
    }
}

