//
//  EmailTemplateHeaderView.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 22/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class EmailTemplateHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    
    class var reuseIdentifier: String {
      return String(describing: self)
      }
      class var nib: UINib {
      return UINib(nibName: String(describing: self), bundle: nil)
      }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        lblEventName.superview!.layer.masksToBounds = false
        lblEventName.superview!.layer.cornerRadius = 3
        lblEventName.superview!.layer.shadowColor = UIColor.gray.cgColor
        lblEventName.superview!.layer.shadowPath = UIBezierPath(roundedRect: lblEventName.superview!.bounds, cornerRadius: lblEventName.superview!.layer.cornerRadius).cgPath
        lblEventName.superview!.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        lblEventName.superview!.layer.shadowOpacity = 0.5
        lblEventName.superview!.layer.shadowRadius = 3.0
    }
    
    
}
