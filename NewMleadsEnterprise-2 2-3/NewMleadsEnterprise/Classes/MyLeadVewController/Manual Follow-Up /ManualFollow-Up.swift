//
//  ManualFollow-Up.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 28/02/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class ManualFollow_Up: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txwComment: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtFollo: UITextField!
    @IBOutlet weak var btnfollowclick: UIButton!
    
    var initialStartDate = Date()
    var EvntStartDate = Date()
    var selectedLeadStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Manual Follow-Up"

        self.viewDate.setShadowColor()
        self.txwComment.layer.borderColor = UIColor.lightGray.cgColor
        self.txwComment.layer.borderWidth = 1
        
        self.btnSave.layer.cornerRadius = 10
        self.btnSave.clipsToBounds = true
        
    }
    
    @IBAction func Save(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFollowupclicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: contentView , baseViewController: self, title: "Select Status", choices: ["Call", "SMS", "Email", "Call"] , initialRow:selectedLeadStatus, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.txtFollo.text = selectedString
            self.selectedLeadStatus = selectedRow
            },cancelAction: { print("cancel")})
    }
     
    @IBAction func btnDateClicked(_ sender: Any) {
        view.endEditing(true)

        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: contentView, baseViewController: self, title: "Start Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            self.EvntStartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "MM-dd-yyyy")
            print("startDate : \(startDate)")
            self.lblDate.text = startDate

        }, cancelAction: {print("cancel")})
    }
    
}

extension ManualFollow_Up : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        if self.txwComment.text == "Enter Comment"{
            self.txwComment.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if self.txwComment.text == "" {
            self.txwComment.text = "Enter Comment"
        }
    }
    
}
