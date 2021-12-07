//
//  AddAddressViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 25/04/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

protocol passLeadAddressDelegate {
    func passAddress(strStreet:String, strCity:String, strState:String, strCountry:String, strZipcode:String)
}

class AddAddressViewController: UIViewController {

    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!

    var delegateAddressData:passLeadAddressDelegate?
    
    var strStreet = ""
    var strCity = ""
    var strState = ""
    var strCountry = ""
    var strZipcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Address"
        
        txtStreet.text = strStreet
        txtCity.text = strCity
        txtState.text = strState
        txtCountry.text = strCountry
        txtZipcode.text = strZipcode

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        if txtStreet.text!.isEmpty || txtCity.text!.isEmpty || txtState.text!.isEmpty || txtCountry.text!.isEmpty || txtZipcode.text!.isEmpty{
            ShowAlert(title: "Mleads", message: "All fields are required", buttonTitle: "Ok") {
            }
        }else{
            
            ShowAlert(title: "", message: "Address Saved successfully", buttonTitle: "Ok") {
                self.delegateAddressData?.passAddress(strStreet: self.txtStreet.text!, strCity: self.txtCity.text!, strState: self.txtState.text!, strCountry: self.txtCountry.text!, strZipcode: self.txtZipcode.text!)
                self.navigationController?.popViewController(animated: true)
            }
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
