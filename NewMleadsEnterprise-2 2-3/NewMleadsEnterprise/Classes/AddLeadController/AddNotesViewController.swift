//
//  AddNotesViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 25/04/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

protocol passLeadNotesDelegate {
    func passNotes(strNotesData:String)
}

class AddNotesViewController: UIViewController {

    @IBOutlet weak var viewNotesObj: UIView!
    @IBOutlet weak var txtNote: UITextView!

    var strNotes = ""
    
    var delegateNotesData:passLeadNotesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNote.text = strNotes.count > 0 ? strNotes : "Add your note here ..."
        txtNote.textColor = strNotes.count > 0 ? UIColor.black : UIColor.lightGray
        
        self.navigationController?.title = "Add Note"

        viewNotesObj.layer.cornerRadius = 3
        viewNotesObj.layer.borderWidth = 1
        viewNotesObj.layer.borderColor = UIColor.gray.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        if txtNote.text.isEmpty{
            ShowAlert(title: "", message: "Please Enter Note", buttonTitle: "Ok") {
            }
        }else{
            delegateNotesData?.passNotes(strNotesData: txtNote.text!)
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


extension AddNotesViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtNote.text.isEmpty {
            txtNote.text = "Add your note here ..."
            txtNote.textColor = UIColor.lightGray
        }
    }
    
}

