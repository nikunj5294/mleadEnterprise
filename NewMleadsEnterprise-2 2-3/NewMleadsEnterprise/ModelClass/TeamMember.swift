//
//  TeamMember.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 27/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class TeamMember: NSObject,NSCoding {

    var first_name:String? = nil
    var last_name:String? = nil
    var reportsTo:String? = nil
    var created_timestamp:String? = nil
    var export_allowed:String? = nil
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
       
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        self.reportsTo = aDecoder.decodeObject(forKey: "reportsTo") as? String
        self.created_timestamp = aDecoder.decodeObject(forKey: "created_timestamp") as? String
        self.export_allowed = aDecoder.decodeObject(forKey: "export_allowed") as? String
    }
    
    open func encode(with aCoder: NSCoder){
  
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(reportsTo, forKey: "reportsTo")
        aCoder.encode(created_timestamp, forKey: "created_timestamp")
        aCoder.encode(export_allowed, forKey: "export_allowed")
    }
}
