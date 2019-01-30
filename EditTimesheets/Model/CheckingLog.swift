//
//  CheckingLog.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/29/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import Foundation

class CheckingLog {
    var historyCheckingLogList: [HistoryCheckingLog]?
    
    var fixed: Bool?
    
    var existSetting: Bool?
    
    init(dict: NSDictionary) {
        if let historyCheckingLogListDict = dict["historyCheckingLogList"] as? [NSDictionary] {
            self.historyCheckingLogList = historyCheckingLogListDict.map({ return HistoryCheckingLog(dict: $0) })
        }
        self.fixed = dict["fixed"] as? Bool
        self.existSetting = dict["existSetting"] as? Bool
    }
}
