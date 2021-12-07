//
//  SystemOptionFollow-UpAction.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 03/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import Alamofire

class SystemOptionFollow_UpAction: UIViewController {

    @IBOutlet weak var tbFollowup: UITableView!
    
    var arrMasterData : [FollowUpList] = []
    var arrUserActionList : [FollowUpList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbFollowup.dataSource = self
        self.tbFollowup.delegate = self
        
        self.AlamofireGetFollowUpData()
        
        //        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject]
        //
        //                    WebServiceCH.shared.RequesURL(ServerURL.getCustomLeadFollowUpList, Perameters: param, showProgress: true) { (result, status) in
        //
        //                        debugPrint("result",result)
        //                    }
        //                    failure: { (error) in
        //                        debugPrint("error",error)
        //                    }

        // Do any additional setup after loading the view.
    }

    @IBAction func Add(_ sender: Any) {
        // SystemOptionAddFollowUpAction
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionAddFollowUpAction") as! SystemOptionAddFollowUpAction
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension SystemOptionFollow_UpAction : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Master Follow-Up Action"
        }
        else{
            return "User Defined Follow-Up Action"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.arrMasterData.count
        }
        else{
            return self.arrUserActionList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SystemOptionFollowUpDataCell", for: indexPath) as! SystemOptionFollowUpDataCell
        
        if indexPath.section == 0{
            cell.lblOther.text = self.arrMasterData[indexPath.row].action
        }
        else{
            cell.lblOther.text = self.arrUserActionList[indexPath.row].action
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            let actionSheet = UIAlertController(title: "", message: "Choose a Action", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (ImageData) in
                print("Edit")
                // SystemOptionAddFollowUpAction
                let storyboard = UIStoryboard(name: "Setting", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionAddFollowUpAction") as! SystemOptionAddFollowUpAction
                vc.isUpdate = true
                vc.DataUpdate = self.arrUserActionList[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (ImageData) in
                print("Delete")
                // create the alert
                       let alert = UIAlertController(title: "", message: "Are you sure, you want to delete?", preferredStyle: UIAlertController.Style.alert)

                       // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (Alert) in
                    print("Delete")
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (Action) in
            }))
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension SystemOptionFollow_UpAction {

    func AlamofireGetFollowUpData(){

        let url = ServerURL.getCustomLeadFollowUpList
        debugPrint("URK",WEBSERVICE_URL + "getFollowUpActionList.php")
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
                    let FollowupData = data["getFollowUpActionList"] as? [String:Any] ?? [:]
                    if let Status = FollowupData["status"] as? String {
                        if Status == "NO"{
                            print("No")
                        }
                        else
                        {
                            print("Yes")
                            let MasterActionData = FollowupData["masterActionList"] as? [[String:Any]] ?? []
                            let UserActionData = FollowupData["userActionList"] as? [[String:Any]] ?? []
                            self.arrMasterData = FollowUpList.FollowupData(dic: MasterActionData)
                            self.arrUserActionList = FollowUpList.FollowupData(dic: UserActionData)
                            self.tbFollowup.reloadData()
//                            if userProductData.isEmpty{
//                                self.isNodata = true
//                            }
//                            else
//                            {
//                                self.isNodata = false
//                            }
//                            self.tbProduct.reloadData()
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

class SystemOptionFollowUpDataCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblOther: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMain.layer.cornerRadius = 5
        self.viewMain.clipsToBounds = true
        self.viewMain.layer.borderColor = UIColor.lightGray.cgColor
        self.viewMain.layer.borderWidth = 1
    }
}
