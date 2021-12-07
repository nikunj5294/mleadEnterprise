//
//  SystemOptionLeadQualifiers.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 02/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire

class SystemOptionLeadQualifiers: UIViewController{

    @IBOutlet weak var tbLead: UITableView!
    
    var arrLeadData : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.AlamofireGetLeadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.AlamofireGetLeadData()
    }

    @IBAction func Add(_ sender: Any) {
        // SystemOptionAddCustomLead
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionAddCustomLead") as! SystemOptionAddCustomLead
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func JSONgetCustomLeadStatusList(){
        
//        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject]
//        
//        WebServiceCH.shared.RequesURL(ServerURL.getCustomLeadStatusList, Perameters: param, showProgress: true) { (result, status) in
//            
//            debugPrint("result",result)
//        }
//        failure: { (error) in
//            debugPrint("error",error)
//        }

        
    }
}

extension SystemOptionLeadQualifiers : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SystemOptionLeadQualifiersDataCell", for: indexPath) as! SystemOptionLeadQualifiersDataCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: "", message: "Choose a Action", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (ImageData) in
            print("Edit")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (ImageData) in
            // create the alert
                   let alert = UIAlertController(title: "", message: "Are you sure to delete this lead qualifier?", preferredStyle: UIAlertController.Style.alert)

                   // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (Alert) in
                print("Delete")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            print("Delete")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (Action) in
        }))
        
//        if UIDevice.current.userInterfaceIdiom == .pad{
//            actionSheet.popoverPresentationController?.sourceView = sender as! UIView
//            actionSheet.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
//            actionSheet.popoverPresentationController?.permittedArrowDirections = .up
//        }
//        else
//        {
//            
//        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

class SystemOptionLeadQualifiersDataCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var imgLead: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMain.layer.cornerRadius = 5
        self.viewMain.clipsToBounds = true
        self.viewMain.layer.borderColor = UIColor.lightGray.cgColor
        self.viewMain.layer.borderWidth = 1
    }
}

extension SystemOptionLeadQualifiers {

    func AlamofireGetLeadData(){

        let url = "https://www.myleadssite.com/MLeads9.7.22/getCustomLeadStatusList.php"
        debugPrint("URK",WEBSERVICE_URL + "getCustomLeadStatusList.php")
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject]

        Alamofire.request(url, method: .post, parameters: param as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            let json = JSON(data: response.data!)
            print(json)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //self.AIView.stopAnimating()
                    let data = response.result.value as! [String : Any]
                    print(data)
                    let CustomLeadStatus = data["getCustomLeadStatus"] as? [String:Any] ?? [:]
                    if let Status = CustomLeadStatus["status"] as? String {
                        if Status == "NO"{
                            print("No")
                        }
                        else
                        {
                            print("Yes")
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

