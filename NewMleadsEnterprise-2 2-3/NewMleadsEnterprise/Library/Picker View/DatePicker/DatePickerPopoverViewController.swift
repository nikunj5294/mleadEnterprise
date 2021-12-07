//
//  DatePickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

class DatePickerPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var doneAction: ((Date)->Void)?
    var cancleAction: (()->Void)?
    var clearAction: (()->Void)?
    
    @IBOutlet weak var picker: UIDatePicker!
    
    var selectedDate = Date()
    var dateMode: UIDatePicker.Mode = .date
    var hideClearButton: Bool = false

    @IBOutlet weak var clearButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if hideClearButton {
            clearButton.removeFromSuperview()
            view.layoutIfNeeded()
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.minimumDate = currentDate
        picker.date = selectedDate
        picker.datePickerMode = dateMode
    }
    
    
    @IBAction func btnDone(_ sender: Any) {
        doneAction?(picker.date)
        dismiss(animated: true, completion: {})
    }

    @IBAction func btnCancel(_ sender: Any) {
        cancleAction?()
        dismiss(animated: true, completion: {})
    }
   
    
    @IBAction func btnClear(_ sender: Any) {
        clearAction?()
        dismiss(animated: true, completion: {})
    }
    //    @IBAction func tappedClear(_ sender: UIButton? = nil) {
//        clearAction?()
//        dismiss(animated: true, completion: {})
//    }
    
    /// popover dismissed
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        btnCancel((Any).self)
    }
    
    /// Popover appears on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
