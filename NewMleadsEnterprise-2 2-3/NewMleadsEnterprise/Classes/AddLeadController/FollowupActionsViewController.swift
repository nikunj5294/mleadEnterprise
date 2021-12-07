//
//  FollowupActionsViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 27/04/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

protocol passFollowUpActionsDelegate {
    func passFollowUpActions(str:String, strIDs:String)
}

class FollowupActionsViewController: UIViewController {

    @IBOutlet weak var imgCallObj: UIImageView!
    @IBOutlet weak var imgSMSObj: UIImageView!
    @IBOutlet weak var imgEmailObj: UIImageView!
    
    @IBOutlet weak var btnCallObj: UIButton!
    @IBOutlet weak var btnSMSObj: UIButton!
    @IBOutlet weak var btnEmailObj: UIButton!

    var delegatePassFollowUpAction:passFollowUpActionsDelegate?
    var strSelectedActions = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEditData()
        
        // Do any additional setup after loading the view.
    }
    
    func setupEditData()  {
        
        imgCallObj.image = UIImage(named: strSelectedActions.contains("Call") ? "checkbox" : "uncheckbox")
        imgSMSObj.image = UIImage(named: strSelectedActions.contains("SMS") ? "checkbox" : "uncheckbox")
        imgEmailObj.image = UIImage(named: strSelectedActions.contains("Email") ? "checkbox" : "uncheckbox")
        btnCallObj.isSelected = strSelectedActions.contains("Call") ? true : false
        btnSMSObj.isSelected = strSelectedActions.contains("SMS") ? true : false
        btnEmailObj.isSelected = strSelectedActions.contains("Email") ? true : false
    }
    
    @IBAction func followUpActionsClicked(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        switch sender.tag {
        case 0:
            imgCallObj.image = UIImage(named: sender.isSelected ? "checkbox" : "uncheckbox")
        case 1:
            imgSMSObj.image = UIImage(named: sender.isSelected ? "checkbox" : "uncheckbox")
        case 2:
            imgEmailObj.image = UIImage(named: sender.isSelected ? "checkbox" : "uncheckbox")
        default:
            print("")
        }
        
    }
    
    
    @IBAction func btnCancelOkClicked(_ sender: UIButton) {
        
        var arrFollowUpActions = [String]()
        var arrFollowUpActionsTags = [String]()

        switch sender.tag {
        case 0:
            if btnCallObj.isSelected{
                arrFollowUpActions.append("Call")
                arrFollowUpActionsTags.append("1")
            }
            if btnSMSObj.isSelected{
                arrFollowUpActions.append("SMS")
                arrFollowUpActionsTags.append("2")
            }
            if btnEmailObj.isSelected{
                arrFollowUpActions.append("Email")
                arrFollowUpActionsTags.append("3")
            }
            delegatePassFollowUpAction?.passFollowUpActions(str: arrFollowUpActions.joined(separator: ","), strIDs: arrFollowUpActionsTags.joined(separator: ","))
            self.dismiss(animated: true, completion: nil)
        case 1:
            self.dismiss(animated: true, completion: nil)
        default:
            print("")
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
