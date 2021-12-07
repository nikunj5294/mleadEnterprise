//
//  SystemOptionScriptionPlan.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 05/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class SystemOptionScriptionPlan: UIViewController, UITextFieldDelegate,  UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tbSuscription: UITableView!
    @IBOutlet weak var lblTeamMemberName: UITextField!
    
    var myPickerView : UIPickerView!
    var pickerData : [String] = []
    var arrSectionData = ["MLeads Paid Subscription Plan","iTunes Subscription Terms"]
    var arrRowData = ["➤ Unlimited Leads\n\n➤ Unlimited Access to All Features\n\n➤ No Annual Contract Required\n\n➤ Subscribe for: 3,6,or 12 months\n\n➤ Include all features like Leads research, Leads follow-up, Track Sales, Sales opportunity\n\n➤ Import and Export Leads\n\n➤ Measure Reports","Your MLeads subscription follows all of Apple's standard iTunes subscription terms and conditions:\n\n1. Payment will be charged to iTunes Account at confirmation of purchase\n\n2. Subscription automatically renews unless autorenew is turned off at least 24-hours before the end of the current period\n\n3. Account will be charged for renewal within 24-hours prior to the end if the current period,and identify the cost of renewal\n\n4. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Setting after purchase\n\n5. Any unused portion of a free trial period,if offered, will be forfeited when the user purchases a subscription to that publication,where applicable\n\nFor more information please review terms of use and privacy policy on below link \nhttps://myleadssite.com/terms.php"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = "\(objLoginUserDetail.firstName!) \(objLoginUserDetail.lastName!)"
        self.pickerData.append(name)
        self.lblTeamMemberName.text = "\(objLoginUserDetail.firstName!) \(objLoginUserDetail.lastName!)"
        self.lblTeamMemberName.delegate = self
    }
    
    // Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    self.pickUp(lblTeamMemberName)
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
     }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.lblTeamMemberName.text = pickerData[row]
     }

    
    func pickUp(_ textField : UITextField){

    // UIPickerView
    self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
    self.myPickerView.delegate = self
    self.myPickerView.dataSource = self
    self.myPickerView.backgroundColor = UIColor.white
    textField.inputView = self.myPickerView

    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
    toolBar.sizeToFit()

    // Adding Button ToolBar
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SystemOptionScriptionPlan.doneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SystemOptionScriptionPlan.cancelClick))
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    textField.inputAccessoryView = toolBar

     }
    
    @objc func doneClick() {
      lblTeamMemberName.resignFirstResponder()
     }
    
    @objc func cancelClick() {
      lblTeamMemberName.resignFirstResponder()
    }

}

extension SystemOptionScriptionPlan : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return self.arrSectionData[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.arrRowData[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
