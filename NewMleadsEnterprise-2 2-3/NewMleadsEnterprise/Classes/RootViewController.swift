//
//  RootViewController.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 08/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class RootViewController: DLHamburguerViewController {

    let webService : WebService = WebService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func awakeFromNib()
    {
        if USERDEFAULTS.bool(forKey: IS_ALREADY_LOGIN)
        {
            let decodedUserDetail = USERDEFAULTS.object(forKey: LOGIN_USER_Detail) as! Data
            objLoginUserDetail = NSKeyedUnarchiver.unarchiveObject(with: decodedUserDetail) as! UserDetail?
            self.contentViewController = (self.storyboard?.instantiateViewController(withIdentifier: "HomeNevigation"))! as UIViewController
        }
        else
        {                                                                                       //LoginViewController
            self.contentViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))! as UIViewController
        }
        self.menuViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController"))! as UIViewController

    }
}
