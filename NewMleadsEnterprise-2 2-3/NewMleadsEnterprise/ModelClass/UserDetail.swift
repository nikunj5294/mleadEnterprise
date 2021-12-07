//
//  MleadUser.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 01/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
//MleadUser
@objc(UserDetail)
open class UserDetail : NSObject,NSCoding {
    
    var userId:String? = nil
    var firstName:String? = nil
    var lastName:String? = nil
    var userName:String? = nil
    var email:String? = nil
    var password:String? = nil
    
    var createTimeStamp:String? = nil
    var updateTimeStamp:String? = nil
    var status:String? = nil
    var userType:String? = nil
    var companyName:String? = nil
    var address:String? = nil
    var city:String? = nil
    var zipCode:String? = nil
    var state:String? = nil
    var country:String? = nil
    var companyWebsite:String? = nil
    var phone:String? = nil
    var mobile:String? = nil
    //var securityQuestion:String? = nil
    var securityQuesId:String? = nil
    var securityQues:String? = nil
    var securityAnswer:String? = nil
    var hearAbout:String? = nil
    var report:String? = nil
    var companySite:String? = nil
    //var industry:String? = nil
    var industryId:String? = nil
    var registerType:String? = nil
    var mobilePlatfrom:String? = nil
    var ip:String? = nil
    var otherPhone:String? = nil
    var phoneExt:String? = nil
    var iSpeechLibrary:String? = nil
    var isOptInCheck = false
    var jobTitle:String? = nil
    var seeFullHeirarchy:String? = nil
    var leadRetrivalSetting:String? = nil
    var currencySupport:String? = nil
    var export_allowed:String? = nil
    var AddedUserFor:String? = nil
    var white_label_logo:String? = nil
    var profileImage:String? = nil
    var signature:String? = nil
    var allowed_lead_type:String? = nil
    var startupTutEnable:String? = nil
    var eventTutEnable:String? = nil
    var registeredEventId:String? = nil
    var hasnotification:String? = nil
    var hastodaytask:String? = nil
    var hastodaymeeting:String? = nil
    var eventOrganizer:String? = nil
    var currency_id:String? = nil
    var optIn:String? = nil
    
    public required convenience init?(coder MDecoder: NSCoder) {
        self.init()
    
        self.userId = MDecoder.decodeObject(forKey: "userId") as? String
        self.firstName = MDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = MDecoder.decodeObject(forKey: "lastName") as? String
        self.userName = MDecoder.decodeObject(forKey: "userName") as? String
        self.email = MDecoder.decodeObject(forKey: "email") as? String
        self.password = MDecoder.decodeObject(forKey: "password") as? String
        
        //self.createTimeStamp = MDecoder.decodeObject(forKey: "createTimeStamp") as? String
        self.createTimeStamp = MDecoder.decodeObject(forKey: "createdTimeStamp") as? String
        //self.updateTimeStamp = MDecoder.decodeObject(forKey: "updateTimeStamp") as? String
        self.updateTimeStamp = MDecoder.decodeObject(forKey: "updatedTimeStamp") as? String
        self.userType = MDecoder.decodeObject(forKey: "userType") as? String
        self.companyName = MDecoder.decodeObject(forKey: "companyName") as? String
        self.eventOrganizer = MDecoder.decodeObject(forKey: "event_organizer_type") as? String
        
        self.address = MDecoder.decodeObject(forKey: "address") as? String
        self.city = MDecoder.decodeObject(forKey: "city") as? String
        self.zipCode = MDecoder.decodeObject(forKey: "zipCode") as? String
        self.state = MDecoder.decodeObject(forKey: "state") as? String
        self.country = MDecoder.decodeObject(forKey: "country") as? String
        //self.phone = MDecoder.decodeObject(forKey: "phone") as? String
        self.phone = MDecoder.decodeObject(forKey: "phoneNumber") as? String
        //self.mobile = MDecoder.decodeObject(forKey: "mobile") as? String
        self.mobile = MDecoder.decodeObject(forKey: "mobilePhone") as? String
        
        self.companyWebsite = MDecoder.decodeObject(forKey: "companyWebSite") as? String
        //self.securityQuestion = MDecoder.decodeObject(forKey: "securityQuestion") as? String
        self.securityQuesId = MDecoder.decodeObject(forKey: "securityQuesId") as? String
        self.securityQues = MDecoder.decodeObject(forKey: "securityQues") as? String
        self.securityAnswer = MDecoder.decodeObject(forKey: "securityAnswer") as? String
        //self.hearAbout = MDecoder.decodeObject(forKey: "hearAbout") as? String
        self.hearAbout = MDecoder.decodeObject(forKey: "hearForm") as? String
        //self.report = MDecoder.decodeObject(forKey: "report") as? String
        self.report = MDecoder.decodeObject(forKey: "reportsTo") as? String
        
        self.companySite = MDecoder.decodeObject(forKey: "companySite") as? String
        self.industryId = MDecoder.decodeObject(forKey: "industryId") as? String
        self.currency_id = MDecoder.decodeObject(forKey: "currency_id") as? String
        self.optIn = MDecoder.decodeObject(forKey: "optIn") as? String
        
        self.registerType = MDecoder.decodeObject(forKey: "registerType") as? String
        self.mobilePlatfrom = MDecoder.decodeObject(forKey: "mobilePlatefrom") as? String
        self.ip = MDecoder.decodeObject(forKey: "ip") as? String
        
        self.otherPhone = MDecoder.decodeObject(forKey: "otherPhone") as? String
        self.phoneExt = MDecoder.decodeObject(forKey: "phoneExt") as? String
        self.isOptInCheck = (MDecoder.decodeObject(forKey: "isOptInCheck") != nil)
        //self.jobTitle = MDecoder.decodeObject(forKey: "jobTitle") as? String
        self.jobTitle = MDecoder.decodeObject(forKey: "jobtitle") as? String
        self.currencySupport = MDecoder.decodeObject(forKey: "currencySupport") as? String
        
        self.export_allowed = MDecoder.decodeObject(forKey: "export_allowed") as? String
        self.AddedUserFor = MDecoder.decodeObject(forKey: "AddedUserFor") as? String
        self.white_label_logo = MDecoder.decodeObject(forKey: "white_label_logo") as? String
        self.profileImage = MDecoder.decodeObject(forKey: "profileImage") as? String
        self.seeFullHeirarchy = MDecoder.decodeObject(forKey: "seeFullHeirarchy") as? String
        
        self.signature = MDecoder.decodeObject(forKey: "signature") as? String
        self.iSpeechLibrary = MDecoder.decodeObject(forKey: "iSpeechLibrary") as? String
        self.leadRetrivalSetting = MDecoder.decodeObject(forKey: "leadRetrivalSetting") as? String
        self.allowed_lead_type = MDecoder.decodeObject(forKey: "allowed_lead_type") as? String
        self.startupTutEnable = MDecoder.decodeObject(forKey: "startupTutEnable") as? String
        
        self.eventTutEnable = MDecoder.decodeObject(forKey: "eventTutEnable") as? String
        self.registeredEventId = MDecoder.decodeObject(forKey: "registeredEventId") as? String
        self.hasnotification = MDecoder.decodeObject(forKey: "hasenotification") as? String
        self.hastodaytask = MDecoder.decodeObject(forKey: "hastodayTask") as? String
        self.hastodaymeeting = MDecoder.decodeObject(forKey: "hastodaymeeting") as? String
        
    }
    
    open func encode(with MCoder: NSCoder){
        
        MCoder.encode(userId, forKey: "userId")
        MCoder.encode(firstName, forKey: "firstName")
        MCoder.encode(lastName, forKey: "lastName")
        MCoder.encode(userName, forKey: "userName")
        MCoder.encode(email, forKey: "email")
        MCoder.encode(password, forKey: "password")
        
        MCoder.encode(createTimeStamp, forKey: "createdTimeStamp")
        MCoder.encode(updateTimeStamp, forKey: "updatedTimeStamp")
        MCoder.encode(userType, forKey: "userType")
        MCoder.encode(companyName, forKey: "companyName")
        MCoder.encode(eventOrganizer, forKey: "event_organizer_type")
        
        MCoder.encode(address,forKey: "address")
        MCoder.encode(city, forKey: "city")
        MCoder.encode(state, forKey: "state")
        MCoder.encode(zipCode, forKey: "zipcode")
        MCoder.encode(country, forKey: "country")
        MCoder.encode(phone, forKey: "phoneNumber")
        MCoder.encode(mobile, forKey: "mobilePhone")
        
        MCoder.encode(companyWebsite, forKey: "companyWebsite")
        //MCoder.encode(securityQuestion, forKey: "securityQuestion")
        //MCoder.encode(securityQuestion, forKey: "securityQuesId")
        MCoder.encode(securityQuesId, forKey: "securityQuesId")
        MCoder.encode(securityQuesId, forKey: "securityQues")
        MCoder.encode(securityAnswer, forKey: "securityAnswer")
        MCoder.encode(hearAbout, forKey: "hearForm")
        MCoder.encode(report, forKey: "reportsTo")
        
        MCoder.encode(companySite, forKey: "companySite")
        MCoder.encode(industryId, forKey: "industryId")
        MCoder.encode(registerType, forKey: "registerType")
        MCoder.encode(mobilePlatfrom, forKey: "mobilePlatfrom")
        MCoder.encode(ip, forKey: "ip")
        MCoder.encode(currency_id, forKey: "currency_id")
        MCoder.encode(optIn, forKey: "optIn")
        
        MCoder.encode(otherPhone, forKey: "mobilePlatfrom")
        MCoder.encode(phoneExt, forKey: "phoneExt")
        MCoder.encode(isOptInCheck, forKey: "isOptInCheck")
        MCoder.encode(jobTitle, forKey: "jobTitle")
        MCoder.encode(currencySupport, forKey: "currencySupport")
        
        MCoder.encode(export_allowed, forKey: "export_allowed")
        MCoder.encode(AddedUserFor, forKey: "AddedUserFor")
        MCoder.encode(profileImage, forKey: "profileImage")
        MCoder.encode(seeFullHeirarchy, forKey: "seeFullHeirarchy")
        
        MCoder.encode(signature, forKey: "signature")
        MCoder.encode(iSpeechLibrary, forKey: "iSpeechLibrary")
        MCoder.encode(leadRetrivalSetting, forKey: "leadRetrivalSetting")
        MCoder.encode(allowed_lead_type, forKey: "allowed_lead_type")
        MCoder.encode(startupTutEnable, forKey: "startupTutEnable")
        
        MCoder.encode(eventTutEnable, forKey: "eventTutEnable")
        MCoder.encode(registeredEventId, forKey: "registeredEventId")
        MCoder.encode(hasnotification, forKey: "hasnotification")
        MCoder.encode(hastodaytask, forKey: "hastodaytask")
        MCoder.encode(hastodaymeeting, forKey: "hastodaymeeting")    
    }
}
