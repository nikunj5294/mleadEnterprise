//
//  SystemOptionAddFollowUpAction.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 03/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class SystemOptionAddFollowUpAction: UIViewController {

    @IBOutlet weak var txwFollowUpAction: UITextView!
    
    var isUpdate : Bool = false
    
    var DataUpdate = FollowUpList()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isUpdate{
            self.txwFollowUpAction.text = self.DataUpdate.action
        }
    }

    @IBAction func Save(_ sender: Any) {
        if Validation(){
            
        }
    }
    
    func Validation() -> Bool {
        if self.txwFollowUpAction.text!.isEmpty{
            ShowAlert(title: "", message: "Please enter follow up action", buttonTitle: "Ok", handlerCB: nil)
            return false
        }
        return true
    }
}
