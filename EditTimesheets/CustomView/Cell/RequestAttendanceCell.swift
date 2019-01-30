//
//  RequestEditAttendanceCell.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/29/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import UIKit

class RequestAttendanceCell: UITableViewCell {
    // MARK: - UI Property
    @IBOutlet weak var typeRequestView: UIView!
    @IBOutlet weak var typeRequestLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Property
    static let IDENTIFIER = String(describing: RequestAttendanceCell.self)
    
    var request: RequestEditAttendance? {
        didSet {
            bindData()
        }
    }
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initViews()
    }
    
    // MARK: - Config
    fileprivate func initViews() {
        setupTypeRequestView()
    }
    
    fileprivate func setupTypeRequestView() {
        typeRequestView.backgroundColor = UIColor(hex: 0xF2F2F2)
        typeRequestView.layer.cornerRadius = 4
        typeRequestView.layer.masksToBounds = true
        typeRequestView.layer.borderWidth = 0.5
        typeRequestView.layer.borderColor = UIColor(hex: 0x979797).cgColor
    }
    
    // MARK: - UI Action
    
    // MARK: - Handler
    fileprivate func bindData() {
        guard let request = self.request else {
            return
        }
        
        if let startTime = request.startTime, let endTime = request.endTime {
            timeLabel.text = "\(startTime)~\(endTime)"
        }
        
        typeRequestLabel.text = request.reasonCategories?.content
        statusLabel.text = request.requestStatus?.content
    }
    
    // MARK: - Override Function
    
    // MARK: - Notifications
    
    // MARK: - Utils
}
