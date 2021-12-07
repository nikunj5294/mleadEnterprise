//
//  SalesOpportunityViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 27/04/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

protocol passLeadSalesOpportunityDelegate {
    func passSalesOpportunity(strSalesName:String, strTarget:String, strPeriods:String, strTargetFuture:String, strTargetClosingDate:String, strProbabilityClosing:String,
        strRPFDate:String,
        strStrStatus:String
    )
}

class SalesOpportunityViewController: UIViewController {

    @IBOutlet weak var btnPeriodsObj: UIButton!
    @IBOutlet weak var lblPeriodsObj: UILabel!
    
    @IBOutlet weak var btnPercentageClosingObj: UIButton!
    @IBOutlet weak var lblPercentageClosingObj: UILabel!
    
    @IBOutlet weak var btnStatusObj: UIButton!
    @IBOutlet weak var lblStatusObj: UILabel!
    
    var selectedPeriodsIndex = 0
    var selectedPercentageClosingIndex = 0
    var selectedStatusIndex = 0
    
    
    @IBOutlet weak var txtSalesOpportunityName: UITextField!
    @IBOutlet weak var txtTarget: UITextField!
    @IBOutlet weak var txtTargetFuture: UITextField!
    @IBOutlet weak var txtClosingDate: UITextField!
    @IBOutlet weak var txtRPFDate: UITextField!

    var selectedClosingDataDate = Date()
    var selectedRPFDate = Date()

    var delegateSalesOpportunity:passLeadSalesOpportunityDelegate?
    
    
    var strSalesName = ""
    var strTarget = ""
    var strPeriods = ""
    var strTargetfuture = ""
    var strClosingDate = ""
    var strClosingPercentage = ""
    var strRPFDate = ""
    var strStatus = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sales Opportunity"
        
        if strSalesName.count > 0{
            
            txtSalesOpportunityName.text = strSalesName
            txtTarget.text = strTarget
            lblPeriodsObj.text = strPeriods
            txtTargetFuture.text = strTargetfuture
            txtClosingDate.text = strClosingDate
            lblPercentageClosingObj.text = strClosingPercentage
            txtRPFDate.text = strRPFDate
            lblStatusObj.text = strStatus
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPeriodsClicked(_ sender: Any) {
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnPeriodsObj , baseViewController: self, title: "Select Period", choices: ["Quarterly", "Annually"] , initialRow:selectedPeriodsIndex, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.lblPeriodsObj.text = selectedString
            self.selectedPeriodsIndex = selectedRow
            },cancelAction: { print("cancel")})
    }
    
    
    /*
     aryPerOfProbValue = [[NSMutableArray alloc] initWithObjects:@"90%", @"75%", @"50%", @"25%", @"15%", @"10%", @"0%", nil];
     aryStatusNew = [[NSMutableArray alloc] initWithObjects:@"Qualified",@"Quote submitted",@"Closed",@"Cancelled",@"Lose",@"Won", nil];
     */
    
    @IBAction func btnProbabilityPercentageClicked(_ sender: Any) {
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnPercentageClosingObj , baseViewController: self, title: "Select Percentage", choices: ["90%", "75%", "50%", "25%", "15%", "10%", "0%"] , initialRow:selectedPercentageClosingIndex, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.lblPercentageClosingObj.text = selectedString
            self.selectedPercentageClosingIndex = selectedRow
            },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnStatusClicked(_ sender: Any) {
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnStatusObj , baseViewController: self, title: "Select Status", choices: ["Qualified","Quote submitted","Closed","Cancelled","Lose","Won"] , initialRow:selectedStatusIndex, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.lblStatusObj.text = selectedString
            self.selectedStatusIndex = selectedRow
            },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnClickedSave(_ sender: Any) {
        
        
        if txtSalesOpportunityName.text!.isEmpty || txtTarget.text!.isEmpty || lblPeriodsObj.text!.isEmpty || txtTargetFuture.text!.isEmpty || txtClosingDate.text!.isEmpty || lblPercentageClosingObj.text!.isEmpty || txtRPFDate.text!.isEmpty || lblStatusObj.text!.isEmpty {
            
            ShowAlert(title: "", message: "All fields are required", buttonTitle: "Ok") {
            }
            
        }else{
            
            delegateSalesOpportunity?.passSalesOpportunity(strSalesName: txtSalesOpportunityName.text!, strTarget: txtTarget.text!, strPeriods: lblPeriodsObj.text!, strTargetFuture: txtTargetFuture.text!, strTargetClosingDate: txtClosingDate.text!, strProbabilityClosing: lblPercentageClosingObj.text!, strRPFDate: txtRPFDate.text!, strStrStatus: lblStatusObj.text!)
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SalesOpportunityViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtClosingDate{
            
            DatePickerPopover.sharedInstance.selectedDate = selectedClosingDataDate
            DatePickerPopover.appearFrom(originView: textField as UIView, baseView: textField, baseViewController: self, title: "Target Closing Date", dateMode: .date, initialDate: selectedClosingDataDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")

                self.selectedClosingDataDate = selectedDate
                let startDate = Utilities.DateToStringFormatter(Date: self.selectedClosingDataDate, ToString: "MM/dd/yyyy")
                self.txtClosingDate.text = startDate
            }, cancelAction: {print("cancel")})
            
            return false
        }else if textField == txtRPFDate{
            
            DatePickerPopover.sharedInstance.selectedDate = selectedRPFDate
            DatePickerPopover.appearFrom(originView: textField as UIView, baseView: textField, baseViewController: self, title: "RPF Due Date", dateMode: .date, initialDate: selectedRPFDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")

                self.selectedRPFDate = selectedDate
                let startDate = Utilities.DateToStringFormatter(Date: self.selectedRPFDate, ToString: "MM/dd/yyyy")
                self.txtRPFDate.text = startDate
            }, cancelAction: {print("cancel")})
            
            return false
        }
        
        return true
    }
    
}
