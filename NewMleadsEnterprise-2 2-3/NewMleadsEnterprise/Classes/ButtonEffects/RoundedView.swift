//
//  ViewBoaderRounded.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 02/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import UIKit

class RoundedView : UIView {
    
    override func didMoveToWindow() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        //self.layer.borderColor = UIColor.gray.cgColor
        //self.layer.borderColor = [UIColor colorWithRed:170/255 green:170/255 blue:170/255 alpha:1.0].CGColor
        self.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0).cgColor
        var ViewBorder = CAShapeLayer()
        ViewBorder.strokeColor = UIColor.black.cgColor
        ViewBorder.fillColor = nil
        ViewBorder.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 2)]
        ViewBorder.frame = self.bounds
        ViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(ViewBorder)
    }
}
