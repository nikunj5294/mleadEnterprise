//
//  File.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 21/08/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import UIKit

class LeadGroupDetail: NSObject,NSCoding {
   
    
    
    var groupid : String? = nil
    var userid : String? = nil
    var groupname : String? = nil
    var leadSource : String? = nil
    var city : String? = nil
    var state : String? = nil
    var leadGroup : String? = nil
    var groupDate : String? = nil
    var createDate : String? = nil
    var upDate : String? = nil
    var purpose : String? = nil
    var contactPerson : String? = nil
    var phone : String? = nil
    var note : String? = nil
    var createTimeStamp : String? = nil
    var updateTimeStamp : String? = nil
    var status : String? = nil
    var groupType : String? = nil
    var isAgenda : String? = nil
    var groupAddedFor : String? = nil
    var outherPhone : String? = nil
    var phoneExt : String? = nil
    var eventType : String? = nil
    var numberOfLead : String? = nil
    var eventTag : Int?
    

    public required convenience init(coder aDecoder: NSCoder ){
        self.init()
        
        self.groupid = aDecoder.decodeObject(forKey: "groupId") as? String
        self.groupname = aDecoder.decodeObject(forKey: "groupName")as? String
        self.leadSource = aDecoder.decodeObject(forKey: "leadSource") as? String
        self.city = aDecoder.decodeObject(forKey: "city")as? String
        self.state = aDecoder.decodeObject(forKey: "state") as? String
        self.leadGroup = aDecoder.decodeObject(forKey: "leadGroup")as? String
        self.groupDate = aDecoder.decodeObject(forKey: "groupDate")as? String
        self.createDate = aDecoder.decodeObject(forKey: "createDate") as? String
        self.upDate = aDecoder.decodeObject(forKey: "upDate")as? String
        self.purpose = aDecoder.decodeObject(forKey: "purpose") as? String
        self.contactPerson = aDecoder.decodeObject(forKey: "contactPersone")as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
        self.note = aDecoder.decodeObject(forKey: "note")as? String
        self.createTimeStamp = aDecoder.decodeObject(forKey: "createTimeStamp") as? String
        self.updateTimeStamp = aDecoder.decodeObject(forKey: "updateTimeStamp")as? String
        self.status = aDecoder.decodeObject(forKey: "status") as? String
        self.groupType = aDecoder.decodeObject(forKey: "groupType")as? String
        self.isAgenda = aDecoder.decodeObject(forKey: "isAgenda") as? String
        self.groupAddedFor = aDecoder.decodeObject(forKey: "groupAddedFor")as? String
        self.outherPhone = aDecoder.decodeObject(forKey: "outherPhone") as? String
        self.phoneExt = aDecoder.decodeObject(forKey: "phoneExt")as? String
        self.eventType = aDecoder.decodeObject(forKey: "eventType") as? String
        self.numberOfLead = aDecoder.decodeObject(forKey: "numberOfLead")as? String
        self.eventTag = aDecoder.decodeObject(forKey: "eventTag") as? Int
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(groupid, forKey: "groupId")
        aCoder.encode(groupname, forKey: "groupName")
        aCoder.encode(leadSource, forKey: "leadSource")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(leadGroup, forKey: "leadGroup")
        
        aCoder.encode(groupDate, forKey: "groupDate")
        aCoder.encode(createDate, forKey: "createDate")
        aCoder.encode(upDate, forKey: "upDate")
        aCoder.encode(purpose, forKey: "purpose")
        aCoder.encode(contactPerson, forKey: "contactperson")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(note, forKey: "note")
        
        aCoder.encode(createTimeStamp, forKey: "createTimeStamp")
        aCoder.encode(updateTimeStamp, forKey: "updateTimeStamp")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(groupType, forKey: "groupType")
        aCoder.encode(isAgenda, forKey: "isAgenda")
        aCoder.encode(groupAddedFor, forKey: "groupAddedFor")
        
        aCoder.encode(outherPhone, forKey: "outherPhone")
        aCoder.encode(phoneExt, forKey: "phoneExt")
        aCoder.encode(eventType, forKey: "eventType")
        aCoder.encode(numberOfLead, forKey: "numberOfLead")
        aCoder.encode(eventTag, forKey: "eventTag")
       
    }
}


