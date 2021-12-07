//
//  PipeLineViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 17/03/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class PipeLineViewController: UIViewController {
    var yearArray = NSMutableArray()
    var selectedIndex = Int()
    var arrYear = [String]()
    
    var selectedUserID = String()
    var objActionSheet = UIAlertAction()
    
    
    @IBOutlet var containerVirw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("PipLine Button Click")
        StringPickerPopOver.appearFrom(originView: view!, baseView: containerVirw, baseViewController: self, title: "Select Year", choices: yearArray as! [String]  , initialRow: selectedIndex, doneAction: { selectedRow, selectedString in
                print("row \(selectedRow) : \(selectedString)")
                
                self.selectedIndex = selectedRow
            
           
            print("Printed...")
            },cancelAction: { print("cancel")})
        
        if self.yearArray.count > 0 && self.yearArray != nil {
                       //yearArray = nil
        }
        let startYear = 2012
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let stringCurrentYear = formatter.string(from: currentDate)
        let endYear = Int(stringCurrentYear) ?? 0 + 2
        self.yearArray.removeAllObjects()
                   
        for i in startYear...endYear {
            self.yearArray.addObjects(from: [i])
        }
    }
    
    let CurrentSectionIndex: Int = 0
    
}
