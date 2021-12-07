//
//  CreateSetupMeetingNotesVC.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 28/02/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class CreateSetupMeetingNotesVC: UIViewController {

    @IBOutlet weak var viewNotes: UIView!
    @IBOutlet weak var txwNotes: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewNotes.layer.borderWidth = 1
        self.viewNotes.layer.borderColor = UIColor.gray.cgColor
        
        self.btnSave.layer.cornerRadius = 10
        self.btnSave.clipsToBounds = true
        
        self.txwNotes.text = "Add notes here"
        self.txwNotes.textColor = UIColor.gray
    }

    @IBAction func save(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CreateSetupMeetingNotesVC : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        
        if txwNotes.text == "Add notes here"{
            textView.text = ""
        }
        self.txwNotes.textColor = UIColor.black
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text == ""{
            txwNotes.text = "Add notes here"
            self.txwNotes.textColor = UIColor.gray
        }
        else{
            self.txwNotes.textColor = UIColor.black
        }
    }
    
}
