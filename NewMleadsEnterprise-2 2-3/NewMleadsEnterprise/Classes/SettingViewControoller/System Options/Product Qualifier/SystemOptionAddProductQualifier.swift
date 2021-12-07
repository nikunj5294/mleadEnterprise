//
//  SystemOptionAddProductQualifier.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 04/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import Alamofire

class SystemOptionAddProductQualifier: UIViewController {

    @IBOutlet weak var txwProductQualifier: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func Save(_ sender: Any) {
        if Validation(){
            self.AlamofireAddProductData()
        }
    }
    
    func Validation() -> Bool {
        if self.txwProductQualifier.text!.isEmpty{
            ShowAlert(title: "", message: "Please enter product qualifier", buttonTitle: "Ok", handlerCB: nil)
            return false
        }
        return true
    }
}

extension SystemOptionAddProductQualifier {

    func AlamofireAddProductData(){

        let url = "https://www.myleadssite.com/MLeads9.7.22/getAddProduct.php"
        debugPrint("URK",WEBSERVICE_URL + "getAddProduct.php")
        let param:[String : Any] = ["userId":objLoginUserDetail.createTimeStamp!,"product":"\(self.txwProductQualifier.text!)","createdTimeStamp":"0","updatedTimeStamp":"0"]

        Alamofire.request(url, method: .post, parameters: param as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            let json = JSON(data: response.data!)
            print(json)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //self.AIView.stopAnimating()
                    let data = response.result.value as! [String : Any]
                    print(data)
                    let addProduct = data["addProduct"] as? [String:Any] ?? [:]
                    if let Status = addProduct["status"] as? String {
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
