//
//  ShowProfileViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 30/09/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class ShowProfileViewController: UIViewController {

    
    @IBOutlet weak var imgProfileObj: UIImageView!
    var imgProfile = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfileObj.image = imgProfile
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
