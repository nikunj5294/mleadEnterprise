//
//  AddViewController.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 22/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol dismissAddMenuPopUpDelegate {
    func pressAddButtonClicked(index:Int)
}

class AddViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var viewMainObj: UIView!
    @IBOutlet weak var viewSubObj: UIView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var delegate:dismissAddMenuPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        
        viewMainObj.layer.cornerRadius = 5
        viewSubObj.layer.cornerRadius = 5
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnAddEvent(_ sender: Any) {
        delegate?.pressAddButtonClicked(index: 1)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddLead(_ sender: Any) {
        
        delegate?.pressAddButtonClicked(index: 0)
        self.dismiss(animated: true, completion: nil)
        /*
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EVENT_COUNT, params: param, key: "userDetail", delegate: self)
        */
 
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLeadViewController") as! AddLeadViewController
        self.present(vc, animated: true, completion: nil)
         */
    }
    
    @IBAction func btnAddLeadGroup(_ sender: Any) {
        
        delegate?.pressAddButtonClicked(index: 2)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddEmailTemplate(_ sender: Any) {
        delegate?.pressAddButtonClicked(index: 3)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}

//MARK:- WEbservices REsponse MEthod...
extension AddViewController: WebServiceDelegate{
   
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_EVENT_COUNT
        {
            let result = handleWebService.handleGetEventCount(response)
            
            
            
        }
        //        print("selectid \(selectedID) and typeid \(typeID)")
        //isFirstTimeCall = true
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



