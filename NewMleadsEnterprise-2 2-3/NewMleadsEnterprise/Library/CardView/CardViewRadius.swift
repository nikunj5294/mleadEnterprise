//
//  CardView.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 24/01/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation

@IBDesignable class CardViewRadius: UIView {
    var cornnerRadius : CGFloat = 8
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 5
    
    var shadowColour : UIColor = .darkGray
    var shadowOpacity : CGFloat = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = cornnerRadius
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = Float(shadowOpacity)
        
    }
}
