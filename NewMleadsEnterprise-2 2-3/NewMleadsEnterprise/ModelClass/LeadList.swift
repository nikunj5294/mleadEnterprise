//
//  LeadList.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 16/06/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation

class LeadList : NSObject{
    var leadId: String? = nil
    var eventId: String? = nil
    var eventName: String? = nil
    var imgURL: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var company: String? = nil
    var email: String? = nil
    var phone: String? = nil
    var followUpActionList: String? = nil
    var recordSoundUrl: String? = nil
    var notes: String? = nil
    var createTimeStamp: String? = nil
    var updateTimeStamp: String? = nil
    var status: String? = nil
    var photo_path_thumbnail: String? = nil
    var leadStatus: String? = nil
    var Street: String? = nil
    var city: String? = nil
    var state: String? = nil
    var country: String? = nil
    var zipCode: String? = nil
    var oppName: String? = nil
    var strIsOwnEvent: String? = nil
    var target: String? = nil
    var periods: String? = nil
    var targetFuture: String? = nil
    var targetClosing: String? = nil
    var proOfClosing: String? = nil
    var nextStepDate: String? = nil
    var statusNew: String? = nil
    var jobTitle: String? = nil
    var badgeCategory: String? = nil
    var otherPhone: String? = nil
    var phoneExt: String? = nil
    var addedLeadType: String? = nil
    var preSurveyURL: String? = nil
    var postSurveyURL: String? = nil
    var otherEmail: String? = nil
    var endDate: String? = nil
    var leadAddedType: String? = nil
    var sharedID: String? = nil
    var processBadge: String? = nil
    var leadStatusName: String? = nil
    var leadStatusURL: String? = nil
    var nextLeadId: String? = nil
    var previousLeadId: String? = nil
    var subject: String? = nil
    var recipient: String? = nil
    var date: String? = nil
    var isPurchaseEmail: String? = nil
    var dailyRemCount: String? = nil
    var monthlyRemCount: String? = nil
    var purchaseCount: String? = nil
    var surveyAnswer: String? = nil
    var emailSubject: String? = nil
    var emailBody: String? = nil
    var followup_action_list: String? = nil
    
    var attechmentArray = NSArray()
    var deleteIDsArray = NSArray()
    var product = NSArray()
    
    var hasEventAtende: Bool? = nil

    var isSelected: Bool? = nil

 
 
    /*init(attechmentArray: NSArray, deleteIDsArray: NSArray , product: NSArray) {
        self.attechmentArray = attechmentArray
        self.deleteIDsArray = deleteIDsArray
        self.product = product
        super.init()
    }*/
}

class attechmentArray: LeadList{
    
}
class deleteIDsArray: LeadList{
    
}
class product: LeadList {
    
}
