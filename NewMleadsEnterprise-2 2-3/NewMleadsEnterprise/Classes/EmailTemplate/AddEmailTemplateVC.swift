//
//  AddEmailTemplateVC.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 22/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class AddEmailTemplateVC: UIViewController {

    var isEdit = false
    var selectedMessage:MessageList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = (isEdit ? "Edit Email Template" : "Add Email Template")
        
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
