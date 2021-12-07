//
//  LeadTeamPopupViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 06/07/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class LeadTeamPopupViewController: UIViewController {

    @IBOutlet var btnTeamMemberOutlet: UIButton!
    @IBOutlet var btnEventsOrGroupOutlet: UIButton!
    @IBOutlet var btnLeadStatusOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func btnTeamMemberAction(_ sender: Any) {
    }
    
    @IBAction func btnEvntsOrGroupAction(_ sender: Any) {
        
//        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: nil, baseViewController: self, title: "Select Duration", choices: arrWithinEvents.duration , initialRow:selectedIndexForEventsWithin, doneAction: { selectedRow, selectedString in
//            print("row \(selectedRow) : \(selectedString)")
//            
//            self.selectedIndexForEventsWithin = selectedRow
//            self.typeID = arrWithinEvents.typeID[self.selectedIndexForEventsWithin]
//            self.lblEventWithin.text = selectedString
//            print("For Evenyt Within = \(self.selectedIndexForEventsWithin)")
//            print("typeid = \(self.typeID)")
//            //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
//            
//        } ,cancelAction: { print("cancel")})
        
    }
    
    @IBAction func btnLeadStatusAction(_ sender: Any) {
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
