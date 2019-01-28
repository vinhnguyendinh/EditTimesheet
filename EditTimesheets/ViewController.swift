//
//  ViewController.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/25/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - UI Property
    @IBOutlet weak var scrollView: UIScrollView!
    
    var addInforView: AddInforCheckInCheckOutView?
    
    var heightAddInforViewConstraint: NSLayoutConstraint?
    
    // MARK: - Property
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViews()
    }
    
    // MARK: - Config
    func initViews() {
        setupAddInforView()
    }
    
    fileprivate func setupAddInforView() {
        addInforView = AddInforCheckInCheckOutView(frame: .zero)
        addInforView?.translatesAutoresizingMaskIntoConstraints = false
        addInforView?.delegate = self
        
        scrollView.addSubview(addInforView!)

        addInforView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addInforView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addInforView?.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        heightAddInforViewConstraint = addInforView?.heightAnchor.constraint(equalToConstant: 176)
        heightAddInforViewConstraint?.isActive = true
    }
    
    // MARK: - UI Action
    
    // MARK: - Handler
    fileprivate func updateContentSizeScrollView() {
        var height: CGFloat = 0

        if let heightAddInforView = self.heightAddInforViewConstraint?.constant {
            height = height + heightAddInforView
        }

        scrollView.contentSize.height = height
    }
    
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
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didAddInputView inputView: InputCheckInCheckOutView) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        heightAddInforViewConstraint.constant = heightAddInforViewConstraint.constant + HEIGHT_INPUT_VIEW_DEFAULT
        
        updateContentSizeScrollView()
        updateLayout()
    }
    
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didDeleteInputView inputView: InputCheckInCheckOutView) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        heightAddInforViewConstraint.constant = heightAddInforViewConstraint.constant - inputView.frame.height
        
        updateContentSizeScrollView()
        updateLayout()
    }

    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didSelectTime inputView: InputCheckInCheckOutView, isSelected: Bool) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        let oldHeight = heightAddInforViewConstraint.constant
        let newHeight = isSelected ? oldHeight + HEIGHT_TIME_PICKER : oldHeight - HEIGHT_TIME_PICKER
        heightAddInforViewConstraint.constant = newHeight
        
        updateContentSizeScrollView()
        updateLayout()
    }
    
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didSelectTime inputView: InputCheckInCheckOutView, didChangeHeightComment height: CGFloat) {
        guard let heightAddInforViewConstraint = self.heightAddInforViewConstraint else {
            return
        }
        heightAddInforViewConstraint.constant = heightAddInforViewConstraint.constant + height
        
        updateContentSizeScrollView()
        updateLayout()
    }
}

