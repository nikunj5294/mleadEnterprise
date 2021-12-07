//
//  RoundImageEffects.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 17/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import UIKit

class RoundImageEffects : UIImageView{
    
    override func didMoveToWindow() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
