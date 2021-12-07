//
//  Validate.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 17/06/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
class Validate: NSObject{
    
}
func isEmpty(_ candidate: String?) -> Bool {
    if candidate != nil {
        return candidate?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEqual("") ?? false
    }
    return true
}

