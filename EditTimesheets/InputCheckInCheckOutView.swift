//
//  InputCheckInCheckOutView.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/25/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import UIKit

protocol InputCheckInCheckOutViewDelegate {
    func inputCheckInCheckOutViewDidRemove(_ inputCheckInCheckOutView: InputCheckInCheckOutView)
    func inputCheckInCheckOutView(_ inputCheckInCheckOutView: InputCheckInCheckOutView, didSelectTime isSelected: Bool)
    func inputCheckInCheckOutView(_ inputCheckInCheckOutView: InputCheckInCheckOutView, didChangeHeightComment height: CGFloat)
}

let HEIGHT_TIME_PICKER: CGFloat = 175

class InputCheckInCheckOutView: UIView {
    // MARK: - UI Property
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeRequestLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var heightTimePickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthTypeRequestLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightCommentTextViewConstraint: NSLayoutConstraint!
    
    // MARK: - Property
    var isSelectingTime: Bool = false
    
    var delegate: InputCheckInCheckOutViewDelegate?
    
    var state: EditTimesheetState = .enable {
        didSet {
            refreshUIState()
        }
    }
    
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
        Bundle.main.loadNibNamed(String(describing: InputCheckInCheckOutView.self), owner: self, options: nil)
        contentView.fixInView(self)
        
        initViews()
    }
    
    fileprivate func initViews() {
        setupTypeRequestLabel()
        setupTimePicker()
    }
    
    fileprivate func setupEditTimeLabel() {
        timeLabel.layer.cornerRadius = 8
        timeLabel.layer.borderWidth = 1
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.borderColor = UIColor(hex: 0xA6A6A6).cgColor
        timeLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapTime))
        timeLabel.addGestureRecognizer(tapGesture)
        
        updateTime(date: Date())
    }
    
    fileprivate func setupDisableTimeLabel() {
        timeLabel.layer.borderWidth = 0
        timeLabel.isUserInteractionEnabled = false
    }
    
    fileprivate func setupTypeRequestLabel() {
        typeRequestLabel.text = "出勤"
        typeRequestLabel.backgroundColor = UIColor(hex: 0xF2F2F2)
        typeRequestLabel.layer.cornerRadius = 4
        typeRequestLabel.layer.masksToBounds = true
        widthTypeRequestLabelConstraint.constant = typeRequestLabel.intrinsicContentSize.width + 10
    }
    
    fileprivate func setupEditCommentTextView() {
        commentTextView.placeholder = "コメント・備考"
        commentTextView.placeholderColor = UIColor.init(hex: 0xA6A6A6)
        commentTextView.layer.cornerRadius = 8
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.masksToBounds = true
        commentTextView.layer.borderColor = UIColor(hex: 0xA6A6A6).cgColor
        commentTextView.delegate = self
        commentTextView.isEditable = true
    }
    
    fileprivate func setupDisableCommentTextView() {
        commentTextView.placeholder = ""
        commentTextView.layer.borderWidth = 0
        commentTextView.isEditable = false
    }
    
    fileprivate func setupTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.addTarget(self, action: #selector(timePickerDateChange), for: .valueChanged)
    }
    
    // MARK: - UI Action
    @IBAction func removeButtonClicked(_ sender: Any) {
        self.delegate?.inputCheckInCheckOutViewDidRemove(self)
    }
    
    @objc func handleTapTime(_ gesture: UITapGestureRecognizer) {
        isSelectingTime = !isSelectingTime
        self.delegate?.inputCheckInCheckOutView(self, didSelectTime: isSelectingTime)

        if isSelectingTime {
            timeLabel.layer.borderColor = UIColor(hex: 0xF18D00).cgColor
            heightTimePickerConstraint.constant = HEIGHT_TIME_PICKER
        } else {
            timeLabel.layer.borderColor = UIColor(hex: 0xA6A6A6).cgColor
            heightTimePickerConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func timePickerDateChange(_ picker: UIDatePicker) {
        updateTime(date: picker.date)
    }
    
    // MARK: - Handler
    fileprivate func updateTime(date: Date) {
        let comp = Calendar.current.dateComponents([.hour, .minute], from: date)
        if let hour = comp.hour, let minute = comp.minute {
            let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
            let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
            
            timeLabel.text = "\(hourString):\(minuteString)"
        }
    }
    
    fileprivate func refreshUIState() {
        switch state {
        case .enable:
            setupEditCommentTextView()
            setupEditTimeLabel()
            break
        case .disable:
            setupDisableCommentTextView()
            setupDisableTimeLabel()
            break
        }
    }
    // MARK: - Override Function
    
    // MARK: - Notifications
    
    // MARK: - Utils
}

extension InputCheckInCheckOutView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let heightTextView = newSize.height > 44 ? newSize.height : 44
        heightCommentTextViewConstraint.constant = heightTextView
        self.layoutIfNeeded()
        
        self.delegate?.inputCheckInCheckOutView(self, didChangeHeightComment: heightTextView)
    }
}
