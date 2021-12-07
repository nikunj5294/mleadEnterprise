//
//  SystemOptionProductQualifier.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 04/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire

class SystemOptionProductQualifier: UIViewController {
    
    var isNodata : Bool = false
    var arrProductData : [[String:Any]] = []

    @IBOutlet weak var tbProduct: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.AlamofireGetProductData()
    }
    
    @IBAction func Add(_ sender: Any) {
        // SystemOptionAddProductQualifier
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionAddProductQualifier") as! SystemOptionAddProductQualifier
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SystemOptionProductQualifier : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isNodata{
            return 1
        }
        else
        {
            return self.arrProductData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isNodata{
            let cell = UITableViewCell.init()
            cell.selectionStyle = .none
            cell.textLabel?.text = "No Data Available"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = .boldSystemFont(ofSize: 16.0)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SystemOptionProductQualifierDataCell", for: indexPath) as! SystemOptionProductQualifierDataCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isNodata{
        }
        else
        {
            let actionSheet = UIAlertController(title: "", message: "Choose a Action", preferredStyle: .actionSheet)
                    
                    actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (ImageData) in
                        print("Edit")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isNodata{
            return tableView.frame.size.height - 80
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

class SystemOptionProductQualifierDataCell: UITableViewCell {
    
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

extension SystemOptionProductQualifier {

    func AlamofireGetProductData(){

        let url = "https://www.myleadssite.com/MLeads9.7.22/getProductList.php"
        debugPrint("URK",WEBSERVICE_URL + "getProductList.php")
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
                    let CustomLeadStatus = data["getProductList"] as? [String:Any] ?? [:]
                    if let Status = CustomLeadStatus["status"] as? String {
                        if Status == "NO"{
                            print("No")
                        }
                        else
                        {
                            print("Yes")
                            let userProductData = CustomLeadStatus["userProductList"] as? [[String:Any]] ?? []
                            if userProductData.isEmpty{
                                self.isNodata = true
                            }
                            else
                            {
                                self.isNodata = false
                            }
                            self.tbProduct.reloadData()
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
