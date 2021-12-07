//
//  MapMarkerWindow.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 06/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}

class MapMarkerWindow: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    var selectedTag = 0
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
