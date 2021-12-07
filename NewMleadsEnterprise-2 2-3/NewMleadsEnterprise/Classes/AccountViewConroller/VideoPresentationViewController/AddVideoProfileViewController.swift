//
//  AddVideoProfileViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 27/01/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView

class AddVideoProfileViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var txtVideoName: HoshiTextField!
    @IBOutlet var txtVideoDescription: HoshiTextField!
    @IBOutlet var txtVideoLink: HoshiTextField!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var isEditVideoProfile = Bool()
    var isAddVideoProfile = Bool()
    var alertTitle = String()
    var strVideoProfileDate = String()
    var dateTimeStamp = Date()
    
    var objVideoProfile:VideoProfileDetail = VideoProfileDetail()
    var tempFile = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.navigationItem.title = "Add Video Profile"
        
        

        if isEditVideoProfile
        {
            self.navigationItem.title = "Edit Video Profile"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.btnSaveAction(_:)))
        
            alertTitle = "Edit Video Profile!"
            VideoDataField()
        }
        else if isAddVideoProfile
        {
            alertTitle = "Add Video Presentation!"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.btnSaveAction(_:)))
            let currentDate = Utilities.DateToStringFormatter(Date: Date(), ToString: "MM-dd-yyyy")
            strVideoProfileDate = Utilities.dateFormatter(Date: currentDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
        }
    }
    //MARK:- Custom Function Video Profile DAta...
    func VideoDataField()
    {
        txtVideoName.text = objVideoProfile.name
        txtVideoDescription.text = objVideoProfile.description_Detail
        txtVideoLink.text = objVideoProfile.videoLink
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    func validateUrl (urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    //MARK:-BUtton ACtion ...
    @IBAction func btnSaveAction(_ sender: Any) {
        if  (txtVideoName.text?.isBlank)!
        {
            print("Please Enter Video Name")
                   
            let alert = UIAlertController(title: "", message: "Please Enter Video Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Video Profile Link")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                   
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else if  (txtVideoDescription.text?.isBlank)!
        {
            print("Please Enter Video Description Name.")
                   
            let alert = UIAlertController(title: "", message: "Please Enter Video Description Name.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Video Profile Link")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                   
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else if  (txtVideoLink.text?.isBlank)!
        {
            print("Please Enter Video Link.")
                   
            let alert = UIAlertController(title: "", message: "Please Enter Video Link.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Video Profile Link")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                   
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else if !validateUrl(urlString: self.txtVideoLink.text!){
            print("Please Enter Valid Video Link.")
                   
            let alert = UIAlertController(title: "", message: "Please Enter Valid Video Link.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Video Profile Link")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                   
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else{
            if isEditVideoProfile{
                print("Edit button tapped")
                let param:[String : String] = ["userId":objLoginUserDetail.createTimeStamp!,
                                               "action":"update",
                                               "video_links":txtVideoLink.text!,
                                               "description":txtVideoDescription.text!,
                                               "name":txtVideoName.text!,
                                               "create_timestamp":objVideoProfile.created_TimeStamp!,
                                               "modify_timestamp":objVideoProfile.modify_TimeStamp!]
                    //Progress Bar Loding...
                    let size = CGSize(width: 30, height: 30)
                    self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                
                    webService.doRequestPost(GET_VideoProfile_Link_URL, params: param as [String : AnyObject], key: "videoLinks", delegate: self)
                
            }
            else if isAddVideoProfile
            {
                
                let param:[String : String] = ["userId":objLoginUserDetail.createTimeStamp!,
                                           "action":"add",
                                           "video_links":txtVideoLink.text!,
                                           "description":txtVideoDescription.text!,
                                           "name":txtVideoName.text!,
                                           "datetime":strVideoProfileDate,
                                           "create_timestamp":"\(Int(dateTimeStamp.timeIntervalSince1970))"]
                //Progress Bar Loding...
                let size = CGSize(width: 30, height: 30)
                self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
                webService.doRequestPost(GET_VideoProfile_Link_URL, params: param as [String : AnyObject], key: "videoLinks", delegate: self)
                
            }
        }
    }
}
//MARK:- webservices Delegate Method...
extension AddVideoProfileViewController:WebServiceDelegate{
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
          stopAnimating()
        
        if apiKey == GET_VideoProfile_Link_URL
        {
            if isEditVideoProfile{
                let json = JSON(data: response)
                let result = json["video_manupulation"]
                                          
                if result["status"] == "YES"
                {
                    let alert = UIAlertController(title: "", message: "Video Profile Update Successfully.",  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Edit Video Profile!")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    _ = self.navigationController?.popViewController(animated: true)
                    })
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                                              
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                                              
                }else
                {
                    let alert = UIAlertController(title: "", message: "Video PRofile Not Updated.",  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Edit Video Profile!")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                                              
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                }
            }
            else if isAddVideoProfile{
                let json = JSON(data: response)
                let result = json["video_manupulation"]
                           
                if result["status"] == "YES"
                {
                    let alert = UIAlertController(title: "", message: "Video Profile Added Successfully.",  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Add Video Profile!")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                               
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                               
                }else
                {
                    let alert = UIAlertController(title: "", message: "Video PRofile Not Added.",  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Add Video Profile!")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                               
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                }
            }
        }
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
        
    }
}
