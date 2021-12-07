//
//  ViewDetailViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 24/01/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class VideoViewDetailViewController: UIViewController {

    @IBOutlet var lblVideoName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblVideoLink: UILabel!

    var selecVideoName = String()
    var objVideoLink = VideoProfileDetail()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Video Presantaion"
        self.findHamburguerViewController()?.gestureEnabled = false
     
        lblVideoName.text = objVideoLink.name
        lblDescription.text = objVideoLink.description_Detail
        lblVideoLink.text = objVideoLink.videoLink
    }
}
