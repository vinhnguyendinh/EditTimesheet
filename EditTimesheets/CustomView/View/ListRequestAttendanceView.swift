//
//  ListRequestAttendanceView.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/29/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import UIKit

enum SectionRequestAttendanceType: Int {
    case request = 0
    case addRequest = 1
}

class ListRequestAttendanceView: UIView {
    // MARK: - UI Property
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var timeExtendedLabel: UILabel!
    @IBOutlet weak var timeOTLabel: UILabel!
    @IBOutlet weak var timeSelfStudyLabel: UILabel!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var requestTableView: UITableView!
    
    // MARK: - Property
    var requests: [RequestEditAttendance] = []
    
    var didChangeHeightContent: ((CGFloat) -> Void)?
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Config
    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ListRequestAttendanceView.self), owner: self, options: nil)
        contentView.fixInView(self)
        
        initViews()
    }
    
    fileprivate func initViews() {
        setupTableView()
        setupButtonRequest()
        
        requests = RequestEditAttendance.createDummyData()
        requestTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + self.requestTableView.contentSize.height
            self.didChangeHeightContent?(height)
        }
    }
    
    fileprivate func setupTableView() {
        requestTableView.delegate = self
        requestTableView.dataSource = self
        requestTableView.register(UINib(nibName: RequestAttendanceCell.IDENTIFIER, bundle: nil), forCellReuseIdentifier: RequestAttendanceCell.IDENTIFIER)
        requestTableView.register(UINib(nibName: AddRequestAttendanceCell.IDENTIFIER, bundle: nil), forCellReuseIdentifier: AddRequestAttendanceCell.IDENTIFIER)
        requestTableView.tableFooterView = UIView()
        requestTableView.sectionHeaderHeight = 0
    }
    
    fileprivate func setupButtonRequest() {
        requestButton.layer.cornerRadius = 6
        requestButton.layer.masksToBounds = true
    }
    
    // MARK: - UI Action
    @IBAction func requestButtonClicked(_ sender: Any) {
        
    }
    
    // MARK: - Handler
    
    // MARK: - Override Function
    
    // MARK: - Notifications
    
    // MARK: - Utils

}

extension ListRequestAttendanceView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionRequestAttendanceType(rawValue: section) else { return 0 }
        switch sectionType {
        case .request:
            return requests.count
        case .addRequest:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SectionRequestAttendanceType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sectionType {
        case .request:
            let cell = tableView.dequeueReusableCell(withIdentifier: RequestAttendanceCell.IDENTIFIER, for: indexPath) as! RequestAttendanceCell
            cell.request = self.requests[indexPath.row]
            return cell
        case .addRequest:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddRequestAttendanceCell.IDENTIFIER, for: indexPath) as! AddRequestAttendanceCell
            return cell
        }
    }
}

extension ListRequestAttendanceView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let sectionType = SectionRequestAttendanceType(rawValue: indexPath.section) else {
            return
        }
        switch sectionType {
        case .request:
            break
        case .addRequest:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = SectionRequestAttendanceType(rawValue: indexPath.section) else {
            return 0
        }
        switch sectionType {
        case .request:
            return 48
        case .addRequest:
            return 56
        }
    }
}
