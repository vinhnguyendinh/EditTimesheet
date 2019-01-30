//
//  ViewController.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/25/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import UIKit

enum EditTimesheetState {
    case enable
    case disable
}

class ViewController: UIViewController {
    // MARK: - UI Property
    @IBOutlet weak var scrollView: UIScrollView!
    
    var addInforView: AddInforCheckInCheckOutView?
    var listRequestView: ListRequestAttendanceView?
    
    var heightAddInforViewConstraint: NSLayoutConstraint?
    var heightListRequestViewConstraint: NSLayoutConstraint?

    
    // MARK: - Property
    var state: EditTimesheetState = .enable
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViews()
    }
    
    // MARK: - Config
    func initViews() {
        setupAddInforView()
        setupListRequestView()
        setupConstraints()
    }
    
    fileprivate func setupAddInforView() {
        addInforView = AddInforCheckInCheckOutView(frame: .zero)
        addInforView?.translatesAutoresizingMaskIntoConstraints = false
        addInforView?.delegate = self
        
        addInforView?.state = self.state
    }
    
    fileprivate func setupListRequestView() {
        listRequestView = ListRequestAttendanceView(frame: .zero)
        listRequestView?.didChangeHeightContent = { [weak self] height in
            guard let `self` = self else {
                return
            }
            
            self.heightListRequestViewConstraint?.constant = height
            self.updateLayout()
        }
        
        listRequestView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setupConstraints() {
        // Add Infor View
        scrollView.addSubview(addInforView!)
        
        addInforView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addInforView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addInforView?.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        addInforView?.setNeedsLayout()
        addInforView?.layoutIfNeeded()
        var height = addInforView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height ?? 0
        var frame = addInforView?.frame ?? .zero
        frame.size.height = height
        addInforView?.frame = frame
        
        heightAddInforViewConstraint = addInforView?.heightAnchor.constraint(equalToConstant: height)
        heightAddInforViewConstraint?.isActive = true
        
        // List Request View
        scrollView.addSubview(listRequestView!)
        
        listRequestView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listRequestView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listRequestView?.topAnchor.constraint(equalTo: (addInforView?.bottomAnchor)!).isActive = true
        
        listRequestView?.setNeedsLayout()
        listRequestView?.layoutIfNeeded()
        height = listRequestView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height ?? 0
        frame = listRequestView?.frame ?? .zero
        frame.size.height = height
        listRequestView?.frame = frame
        
        heightListRequestViewConstraint = listRequestView?.heightAnchor.constraint(equalToConstant: height)
        heightListRequestViewConstraint?.isActive = true
        
        listRequestView?.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    // MARK: - UI Action
    
    // MARK: - Handler
    fileprivate func updateLayout() {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Override Function
    
    // MARK: - Notifications
    
    // MARK: - Utils
    
}

extension ViewController: AddInforCheckInCheckOutViewDelegate {
    func addInforCheckInCheckOutViewDidAddInputView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        heightAddInforViewConstraint.constant = heightAddInforViewConstraint.constant + HEIGHT_INPUT_VIEW_DEFAULT
        
        updateLayout()
    }
    
    func addInforCheckInCheckOutViewDidDeleteInputView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, inputView: InputCheckInCheckOutView) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        heightAddInforViewConstraint.constant = heightAddInforViewConstraint.constant - inputView.frame.height
        
        updateLayout()
    }
    
    func addInforCheckInCheckOutViewDidSelectTime(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, isSelected: Bool) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        let oldHeight = heightAddInforViewConstraint.constant
        let newHeight = isSelected ? oldHeight + HEIGHT_TIME_PICKER : oldHeight - HEIGHT_TIME_PICKER
        heightAddInforViewConstraint.constant = newHeight
        
        updateLayout()
    }
    
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didChangeHeightComment height: CGFloat) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        heightAddInforViewConstraint.constant = heightAddInforViewConstraint.constant + height
        
        updateLayout()
    }
}

