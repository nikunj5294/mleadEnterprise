//
//  CreateExpenseTrackingVC.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 28/02/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import Alamofire

class CreateExpenseTrackingVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtExpenceName: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var btnDate: UIButton!
    var initialStartDate = Date()
    var EvntStartDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Expense"

        self.btnSave.layer.cornerRadius = 10
        self.btnSave.clipsToBounds = true
        
    }

    @IBAction func Save(_ sender: Any) {
        if self.validation(){
            self.AlamofireAddProductData()
        }
    }
    
   @IBAction func btnDateClicked(_ sender: Any) {
       view.endEditing(true)

       DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: contentView, baseViewController: self, title: "Start Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
           self.EvntStartDate = selectedDate
           let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "MM-dd-yyyy")
           print("startDate : \(startDate)")
           self.txtDate.text = startDate

       }, cancelAction: {print("cancel")})
   }
    
    func validation() -> Bool{
        
        if self.txtExpenceName.text!.isEmpty{
            ShowAlert(title: "Alert", message: "Please enter expence Name", buttonTitle: "Ok", handlerCB: nil)
            return false
        }
        else if self.txtAmount.text!.isEmpty{
            ShowAlert(title: "Alert", message: "Please enter amount", buttonTitle: "Ok", handlerCB: nil)
            return false
        }
        else if self.txtDate.text!.isEmpty{
            ShowAlert(title: "Alert", message: "Please select date", buttonTitle: "Ok", handlerCB: nil)
            return false
        }
        else if self.txtDescription.text!.isEmpty{
            ShowAlert(title: "Alert", message: "Please ", buttonTitle: "Ok", handlerCB: nil)
            return false
        }
        
        return true
    }
}

extension CreateExpenseTrackingVC {
    
    func AlamofireAddProductData(){

        let url = ServerURL.AddExpenseTracking
        debugPrint("URK",ServerURL.AddExpenseTracking)
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,"leadId":"1613206998" as AnyObject,"text":self.txtExpenceName.text! as AnyObject,"amount":self.txtAmount.text! as AnyObject,"description":self.txtDescription.text! as AnyObject,"date":self.txtDate.text! as AnyObject,"type":"A" as AnyObject,"created_timestamp":"1614242445" as AnyObject,"create_date":"02/03/2021" as AnyObject]

        Alamofire.request(url, method: .post, parameters: param as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            let json = JSON(data: response.data!)
            print(json)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //self.AIView.stopAnimating()
                    let data = response.result.value as! [String : Any]
                    print(data)
                    let CustomLeadStatus = data["getLeadExpenseList"] as? [String:Any] ?? [:]
                    if let Status = CustomLeadStatus["status"] as? String {
                        if Status == "NO"{
                            print("No")
                        }
                        else
                        {
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    }
                }
                break

            case .failure(_):
                //self.AIView.stopAnimating()
                //let _ = Alert(title: "Error", msg: "server or internet error", vc: self)
                break
            }
        }
    }
}
