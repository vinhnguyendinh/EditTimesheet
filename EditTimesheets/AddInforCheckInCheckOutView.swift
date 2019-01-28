//
//  AddInforCheckInCheckOutView.swift
//  EditTimesheets
//
//  Created by Nguyen Vinh on 1/25/19.
//  Copyright © 2019 Nguyen Vinh. All rights reserved.
//

import UIKit

protocol AddInforCheckInCheckOutViewDelegate {
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didAddInputView inputView: InputCheckInCheckOutView)
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didDeleteInputView inputView: InputCheckInCheckOutView)
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didSelectTime inputView: InputCheckInCheckOutView, isSelected: Bool)
    func addInforCheckInCheckOutView(_ addInforCheckInCheckOutView: AddInforCheckInCheckOutView, didSelectTime inputView: InputCheckInCheckOutView, didChangeHeightComment height: CGFloat)
}


let HEIGHT_INPUT_VIEW_DEFAULT: CGFloat = 56

class AddInforCheckInCheckOutView: UIView {
    // MARK: - UI Property
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    // MARK: - Property
    var delegate: AddInforCheckInCheckOutViewDelegate?
    
    // Input view and height input view
    var inputViews: [InputCheckInCheckOutView: NSLayoutConstraint] = [:]
    
    var previousInputView: InputCheckInCheckOutView?
    
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
        Bundle.main.loadNibNamed(String(describing: AddInforCheckInCheckOutView.self), owner: self, options: nil)
        contentView.fixInView(self)
        
        initViews()
    }
    
    fileprivate func initViews() {
        self.setupScrollView()
    }
    
    fileprivate func setupScrollView() {
        scrollView.isScrollEnabled = false
    }
    
    // MARK: - UI Action
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func addInputButtonClicked(_ sender: Any) {
        guard inputViews.count < 96 else {
            return
        }
        
        let inputView = createInputView()
        self.delegate?.addInforCheckInCheckOutView(self, didAddInputView: inputView)
    }
    
    // MARK: - Handler
    fileprivate func createInputView() -> InputCheckInCheckOutView {
        let inputView = InputCheckInCheckOutView(frame: .zero)
        inputView.delegate = self
        
        let heightInputViewConstraint = addInputView(inputView)
        inputViews[inputView] = heightInputViewConstraint
        
        return inputView
    }
    
    fileprivate func addInputView(_ inputView: InputCheckInCheckOutView) -> NSLayoutConstraint {
        scrollView.addSubview(inputView)
        
        inputView.translatesAutoresizingMaskIntoConstraints = false
        
        inputView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        inputView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        let heightInputView: CGFloat = inputView.frame.height > 0 ? inputView.frame.height:  HEIGHT_INPUT_VIEW_DEFAULT
        let heightInputViewConstraint = inputView.heightAnchor.constraint(equalToConstant: heightInputView)
        heightInputViewConstraint.isActive = true
        
        if let previousInputView = self.previousInputView {
            inputView.topAnchor.constraint(equalTo: previousInputView.bottomAnchor).isActive = true
        } else {
            inputView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        }
        
        self.previousInputView = inputView
        
        return heightInputViewConstraint
    }
    
    func addInputViewsToScrollView() {
        removeAllViewInScrollView()
        
        self.inputViews.keys.forEach { (inputView) in
            let _  = addInputView(inputView)
        }
    }
    
    fileprivate func removeAllViewInScrollView() {
        previousInputView = nil
        
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func updateLayout() {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Override Function
    
    // MARK: - Notifications
    
    // MARK: - Utils
}

extension AddInforCheckInCheckOutView: InputCheckInCheckOutViewDelegate {
    func inputCheckInCheckOutViewDidRemove(_ inputCheckInCheckOutView: InputCheckInCheckOutView) {
        self.delegate?.addInforCheckInCheckOutView(self, didDeleteInputView: inputCheckInCheckOutView)
        self.removeInputView(inputCheckInCheckOutView)
    }
    
    func inputCheckInCheckOutView(_ inputCheckInCheckOutView: InputCheckInCheckOutView, didSelectTime isSelected: Bool) {
        self.delegate?.addInforCheckInCheckOutView(self, didSelectTime: inputCheckInCheckOutView, isSelected: isSelected)

        guard let heightInputViewConstraint = inputViews[inputCheckInCheckOutView] else {
            return
        }
        let oldHeight = heightInputViewConstraint.constant
        let newHeight = isSelected ? oldHeight + HEIGHT_TIME_PICKER : oldHeight - HEIGHT_TIME_PICKER
        heightInputViewConstraint.constant = newHeight
        
        updateLayout()
    }
    
    func inputCheckInCheckOutView(_ inputCheckInCheckOutView: InputCheckInCheckOutView, didChangeHeightComment height: CGFloat) {
        guard let heightInputViewConstraint = inputViews[inputCheckInCheckOutView] else {
            return
        }
        let oldHeight = heightInputViewConstraint.constant
        let newHeight = height > HEIGHT_INPUT_VIEW_DEFAULT ? height + 12 : HEIGHT_INPUT_VIEW_DEFAULT
        heightInputViewConstraint.constant = newHeight
        
        updateLayout()
        
        self.delegate?.addInforCheckInCheckOutView(self, didSelectTime: inputCheckInCheckOutView, didChangeHeightComment: newHeight - oldHeight)
    }
    
    fileprivate func removeInputView(_ inputView: InputCheckInCheckOutView) {
        self.inputViews.removeValue(forKey: inputView)
        addInputViewsToScrollView()
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
