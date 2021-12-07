//
//  CustomThemeFile.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 30/04/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct MyTheme {
        static var skyBlue: UIColor  { return UIColor(red: 2/255, green: 168/255, blue: 246/255, alpha: 1.0) }
        //static var secondColor: UIColor { return UIColor(red: 0, green: 1, blue: 0, alpha: 1) }
    }
}

extension UIFont
{
    struct MyFont {
        static var TitleFont: UIFont {
            return UIFont(name: "Gill Sans", size: 25)!
        }
        
        static var textFont: UIFont
        {
            return UIFont(name: "Gill Sans", size: 15)!
        }
        
        static var labelFont: UIFont
        {
            return UIFont(name: "Gill Sans", size: 17)!
        }
    }
}
