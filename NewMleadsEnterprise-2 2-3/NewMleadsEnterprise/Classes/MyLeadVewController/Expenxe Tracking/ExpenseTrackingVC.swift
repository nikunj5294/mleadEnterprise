//
//  ExpenseTrackingVC.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 28/02/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import Alamofire

class ExpenseTrackingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Expense Tracking"

        let btnCreateTask = UIBarButtonItem(image: UIImage.init(named: "addnew") , style: .plain, target: self, action: #selector(self.btnCreateTask(_:)))
        btnCreateTask.tintColor = .white
        navigationItem.rightBarButtonItems = [ btnCreateTask]
        
        self.AlamofireGetProductData()
        
    }
    
    @objc func btnCreateTask(_ sender:UIButton) {
        // CreateExpenseTrackingVC
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "CreateExpenseTrackingVC") as! CreateExpenseTrackingVC
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }

}

extension ExpenseTrackingVC {
    
    func AlamofireGetProductData(){

        let url = ServerURL.GetExpenseTrackingList
        debugPrint("URK",ServerURL.GetExpenseTrackingList)
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,"leadId":"1613206998" as AnyObject]

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
                            print("Yes")
                            let userProductData = CustomLeadStatus["userProductList"] as? [[String:Any]] ?? []
                            
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
