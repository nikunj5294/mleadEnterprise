//
//  ButtonRadius.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 08/04/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton : UIButton
{
    override func didMoveToWindow() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 2/255, green: 168/255, blue: 246/255, alpha: 1.0).cgColor
    
//        self.addTarget(self, action: Selector("holdRelease:"), for: UIControl.Event.touchUpInside);
//        self.addTarget(self, action: Selector("HoldDown:"), for: UIControl.Event.touchDown)
//
//        //target functions
//        func HoldDown(sender:UIButton)
//        {
//            self.backgroundColor = UIColor.blue
//        }
//
//        func holdRelease(sender:UIButton)
//        {
//            self.backgroundColor = UIColor.white
//        }
   }
    
}
