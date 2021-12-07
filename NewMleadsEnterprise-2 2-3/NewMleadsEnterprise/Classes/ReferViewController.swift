//
//  ReferViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 20/03/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class ReferViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.findHamburguerViewController()?.gestureEnabled = false
        self.navigationItem.title = "Refer To Friend"
        
        let refCont1 = "You will get 10% discount off the subscription price."
        let refCont2 = "Download Link:"
        let temp = "https://www.myleadssite.com/refer_middle_page.php?refer_key="
    
        let refCont3 = temp + objLoginUserDetail.userId!
        let refCont4 = "I want to refer MLeads"
        let objectToShare = [refCont4,refCont2,refCont3,refCont1]
        
        let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        //activityVC.excludedActivityTypes = [ UIActivity.ActivityType.copyToPasteboard]
        self.present(activityVC, animated: true, completion: nil)
        //let excludeActivities = UIActivity.ActivityType.copyToPasteboard
        //activityVC.excludedActivityTypes = excludeActivities
    }
}
