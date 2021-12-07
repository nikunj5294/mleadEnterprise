//
//  MLeadService.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 10/04/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
/*
class MLeadService: NSObject {
    var appDelegate: AppDelegate?
    var responseData: Data?
    var topView: UIViewController?
    var tempSelser = ""
    var delegate: Any?
    
    override init?() {
        super.init()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        topView = APPLICATION_DELEGATE.navigationController?.viewControllers.last
    }
}
var delegate: Any?
func loginDeviceRespnse(_ UserID: String?, udid strUDID: String?)
{
}
//MARK: Authentication
func authentication(withWebService strUserName: String?, password strPassword: String?, udid strudid: String?) {
    
    print("\(strudid)")
    
    var dict = ["userName" : strUserName,
                "password" : strPassword,
                "deviceType" : "ios",
                "udid" : strudid]
    
    var objWebServiceCon = WebServiceConnection(jsonKey: "userLogin", jsonValues: dict, url: LOGIN_API_URL, notificationName: LOGIN_NOTIFICATION)
    
    // C Code Check This
    //[dict release];
    //[objWebServiceCon release];
}

func authentication(withLocalDB strUserName: String?, password strPassword: String?) -> Bool {
    var isLogin = false
    if appDelegate.objSqliteDatabase.checkIfDataAvailable() {
        if appDelegate.objSqliteDatabase.checkLogin(by: strUserName, password: strPassword) {
            isLogin = true
        } else {
            var viewAlert = UIViewAlertMessage(frame: CGRect(x: 0, y: 0, width: topView.view.frame.size.width, height: topView.view.frame.size.height), message: NSLocalizedString("InvalideAuthKey", comment: ""), withButtons: NSLocalizedString("OkButtonKey", comment: ""), nil)
            viewAlert.delegate = nil
            topView.view.addSubview(viewAlert)
            viewAlert.show()
            
            isLogin = false
        }
    }
    else{
        var viewAlert = UIViewAlertMessage(frame: CGRect(x: 0, y: 0, width: topView.view.frame.size.width, height: topView.view.frame.size.height), message:NSLocalizedString("FirstLoginKey", comment: ""), withButtons: NSLocalizedString("OkButtonKey", comment: ""), nil)
        viewAlert.delegate = nil
        topView.view.addSubview(viewAlert)
        viewAlert.show()
        
        isLogin = false
    }
    return isLogin
}

//MARK: HandleWeb Services Responces..
func handleWebServiceResponseforAuth(_ notification: Notification?) -> Bool {
    var isLogin = false
    
    if notification.object() != nil {
        var dict = notification.object().jsonValue()
        var respDict = dict["userLogin"] as? [AnyHashable : Any]
        appDelegate.isTermsModified = false
        
        if (respDict["status"] == "YES") {
            var flag = respDict["Active_terms_flag"] as? String
            print("Flag is :\(flag ?? "")")
            
            if (flag == "0") {
                appDelegate.isTermsModified = true
                var Link = respDict["LINK"] as? String
                
                var url = "\(EULA)\(Link ?? "")"
                appDelegate.updatesTermsLink = url
                print("TermsURL :\(url)")
            } else{
                appDelegate.isTermsModified = false
            }
        }
        
        if (respDict["status"] == "YES") && ((respDict["userType"]?.uppercased() == USER_TYPE_FOR_APP) || (respDict["userType"]?.uppercased() == BUSINESS_USER_TYPE)) {
            
            if (respDict["userType"]?.uppercased() == USER_TYPE_FOR_APP) {
                appDelegate.strApplicationUserType = USER_TYPE_FOR_APP
            } else if (respDict["userType"]?.uppercased() == BUSINESS_USER_TYPE) {
                appDelegate.strApplicationUserType = BUSINESS_USER_TYPE
            }
            
            APPLICATION_DELEGATE.createFolderIfNotExist(forLoginUserId: respDict["userId"])
            
            getUserInfoByID(fromWebService: respDict["userId"])
            isLogin = true
        }
            
        else if (respDict["status"] == "YES") && (respDict["userType"]?.uppercased() == "F") {
            var viewAlert = UIViewAlertMessage(frame: CGRect(x: 0, y: 0, width: topView.view.frame.size.width, height: topView.view.frame.size.height), message: NSLocalizedString("InvalideAuthKeyWithReason", comment: ""), withButtons: NSLocalizedString("OkButtonKey", comment: ""), nil)
            viewAlert.delegate = nil
            topView.view.addSubview(viewAlert)
            viewAlert.show()
            
            isLogin = false
        }
        else if (respDict["status"] == "UDID NOT MATCH") {
            showAlertForOtherDevice()
        }
        else{
            var viewAlert = UIViewAlertMessage(frame: CGRect(x: 0, y: 0, width: topView.view.frame.size.width, height: topView.view.frame.size.height), message: NSLocalizedString("InvalideAuthKey", comment: ""), withButtons: NSLocalizedString("OkButtonKey", comment: ""), nil)
            viewAlert.delegate = nil
            topView.view.addSubview(viewAlert)
            viewAlert.show()
            
            isLogin = false
        }
    }
    return isLogin
}
func getUserInfoByID(fromWebService strUserId: String?) {
    let dict = [ "userId" : strUserId ?? ""]
    let objWebServiceCon = WebServiceConnection(jsonKey: "userDetail", jsonValues: dict, url: GET_USER_INFO_BY_ID_API_URL, notificationName: GET_USER_INFO_NOTIFICATION)
    
    //C Code
    //[dict release];
    //[objWebServiceCon release];
}
//MARK: Show AlertFor Device..

func showAlertForOtherDevice() {
    let viewAlert = UIViewAlertMessage(frame: CGRect(x: 0, y: 0, width: topView.view.frame.size.width, height: topView.view.frame.size.height), message: NSLocalizedString("AlreadyLoginKey", comment: ""), withButtons: NSLocalizedString("OkButtonKey", comment: ""), nil)
    viewAlert.delegate = nil
    topView.view.addSubview(viewAlert)
    viewAlert.show()
}

//MARK:Handle User Info Response

func handleUserInfoResponse(_ notification: Notification?) {
    if notification.object() != nil {
        
        var dict = notification.object().jsonValue()
        var respDict = dict["userDetail"] as? [AnyHashable : Any]
        
        if (respDict["status"] == "YES") {
            
            var dictUserInfo = respDict["userInfoArr"] as? [AnyHashable : Any]
            appDelegate.objCurrentUser = MleadUser()
            if !dictUserInfo["userId"] == NSNull() {
                appDelegate.objCurrentUser.userId = dictUserInfo["userId"]
            }else{
                appDelegate.objCurrentUser.userId = ""
            }
            if !dictUserInfo["userName"] == NSNull() {
                appDelegate.objCurrentUser.userName = "" //[dictUserInfo objectForKey:@"userName"];
            }else{
                appDelegate.objCurrentUser.userName = ""
            }
            if !dictUserInfo["firstName"] == NSNull() {
                appDelegate.objCurrentUser.firstName = dictUserInfo["firstName"]
            }else{
                appDelegate.objCurrentUser.firstName = ""
            }
            if !dictUserInfo["lastName"] == NSNull() {
                appDelegate.objCurrentUser.lastName = dictUserInfo["lastName"]
            }else{
                appDelegate.objCurrentUser.lastName = ""
            }
            
            var data = NSDictionary(contentsOfFile: appDelegate.userInfoPath)
            if AppDel.getTextFromString(data["Password"]).length() > 0 {
                appDelegate.objCurrentUser.password = AppDel.getTextFromString(data["Password"])
            }
            
            if !dictUserInfo["email"] == NSNull() {
                appDelegate.objCurrentUser.email = dictUserInfo["email"]
            }else{
                appDelegate.objCurrentUser.email = ""
            }
            if !dictUserInfo["createdTimeStamp"] == NSNull() {
                appDelegate.objCurrentUser.createTimeStamp = dictUserInfo["createdTimeStamp"]
            }else{
                appDelegate.objCurrentUser.createTimeStamp = ""
            }
            if !dictUserInfo["updatedTimeStamp"] == NSNull() {
                appDelegate.objCurrentUser.updateTimeStamp = dictUserInfo["updatedTimeStamp"]
            }else{
                appDelegate.objCurrentUser.updateTimeStamp = ""
            }
            if !dictUserInfo["companyName"] == NSNull() {
                appDelegate.objCurrentUser.companyName = dictUserInfo["companyName"]
            }elseP{
                appDelegate.objCurrentUser.companyName = ""
            }
            if !dictUserInfo["address"] == NSNull() {
                appDelegate.objCurrentUser.address = dictUserInfo["address"]
            }else{
                appDelegate.objCurrentUser.address = ""
            }
            if !dictUserInfo["city"] == NSNull() {
                appDelegate.objCurrentUser.city = dictUserInfo["city"]
            }else{
                appDelegate.objCurrentUser.city = ""
            }
            if !dictUserInfo["state"] == NSNull() {
                appDelegate.objCurrentUser.state = dictUserInfo["state"]
            }else{
                appDelegate.objCurrentUser.state = ""
            }
            if !dictUserInfo["zipCode"] == NSNull() {
                appDelegate.objCurrentUser.zipCode = dictUserInfo["zipCode"]
            }else{
                appDelegate.objCurrentUser.zipCode = ""
            }
            if !dictUserInfo["country"] == NSNull() {
                appDelegate.objCurrentUser.country = dictUserInfo["country"]
            }else{
                appDelegate.objCurrentUser.country = ""
            }
            if !dictUserInfo["companyWebSite"] == NSNull() {
                appDelegate.objCurrentUser.companyWebsite = dictUserInfo["companyWebSite"]
            }else{
                appDelegate.objCurrentUser.companyWebsite = ""
            }
            if !dictUserInfo["phoneNumber"] == NSNull() {
                appDelegate.objCurrentUser.phone = dictUserInfo["phoneNumber"]
            }else{
                appDelegate.objCurrentUser.phone = ""
            }
            if !dictUserInfo["mobilePhone"] == NSNull() {
                appDelegate.objCurrentUser.mobile = dictUserInfo["mobilePhone"]
            }else{
                appDelegate.objCurrentUser.mobile = ""
            }
            if !dictUserInfo["securityQuesId"] == NSNull() {
                appDelegate.objCurrentUser.securityQuestion = dictUserInfo["securityQuesId"]
            }else{
                appDelegate.objCurrentUser.securityQuestion = ""
            }
            if !dictUserInfo["securityAnswer"] == NSNull() {
                appDelegate.objCurrentUser.answer = dictUserInfo["securityAnswer"]
            }else{
                appDelegate.objCurrentUser.answer = ""
            }
            if !dictUserInfo["hearFrom"] == NSNull() {
                appDelegate.objCurrentUser.hearAbout = dictUserInfo["hearFrom"]
            }else{
                appDelegate.objCurrentUser.hearAbout = ""
            }
            if !dictUserInfo["userType"] == NSNull() {
                appDelegate.objCurrentUser.userType = dictUserInfo["userType"]
            }else{
                appDelegate.objCurrentUser.userType = ""
            }
            if !dictUserInfo["industryId"] == NSNull() {
                appDelegate.objCurrentUser.industry = dictUserInfo["industryId"]
            }else{appDelegate.objCurrentUser.industry = ""}
            if !dictUserInfo["currency_id"] == NSNull() {
                appDelegate.objCurrentUser.currencySupport = dictUserInfo["currency_id"]
            } else {
                appDelegate.objCurrentUser.currencySupport = ""
            }
            if !dictUserInfo["registerType"] == NSNull() {
                appDelegate.objCurrentUser.registerType = dictUserInfo["registerType"]
            } else {
                appDelegate.objCurrentUser.registerType = ""
            }
            if !dictUserInfo["signature"] == NSNull() {
                appDelegate.objCurrentUser.signature = dictUserInfo["signature"]
            } else {
                appDelegate.objCurrentUser.signature = ""
            }
            appDelegate.objCurrentUser.mobilePlatfrom = "iOS"
            
            if !dictUserInfo["event_organizer_type"] == NSNull() {
                appDelegate.objCurrentUser.eventOrganizer = dictUserInfo["event_organizer_type"]
            } else {
                appDelegate.objCurrentUser.eventOrganizer = ""
            }
            if !dictUserInfo["other_phone"] == NSNull() {
                appDelegate.objCurrentUser.otherPhone = dictUserInfo["other_phone"]
            } else {
                appDelegate.objCurrentUser.otherPhone = ""
            }
            if !dictUserInfo["phone_ext"] == NSNull() {
                appDelegate.objCurrentUser.phoneExt = dictUserInfo["phone_ext"]
            } else {
                appDelegate.objCurrentUser.phoneExt = ""
            }
            
            if !dictUserInfo["userType"] == NSNull() {
                appDelegate.objCurrentUser.userType = dictUserInfo["userType"]
            } else {
                appDelegate.objCurrentUser.userType = ""
            }
            if !dictUserInfo["reportsTo"] == NSNull() {
                appDelegate.objCurrentUser.report = dictUserInfo["reportsTo"]
            } else {
                appDelegate.objCurrentUser.report = ""
            }
            
            if !dictUserInfo["optIn"] == NSNull() {
                appDelegate.objCurrentUser.isOptInCheck = (dictUserInfo["optIn"] as? NSNumber)?.boolValue ?? false
            } else {
                appDelegate.objCurrentUser.isOptInCheck = false
            }
            if !dictUserInfo["jobtitle"] == NSNull() {
                appDelegate.objCurrentUser.jobTitle = dictUserInfo["jobtitle"] as? String ?? ""
            } else {
                appDelegate.objCurrentUser.jobTitle = ""
            }
            
            if !dictUserInfo["currency_id"] == NSNull() {
                appDelegate.objCurrentUser.currencySupport = dictUserInfo["currency_id"]
            } else {
                appDelegate.objCurrentUser.currencySupport = "1"
            }
            if !dictUserInfo["export_allowed"] == NSNull() {
                appDelegate.objCurrentUser.export_allowed = dictUserInfo["export_allowed"]
            } else {
                appDelegate.objCurrentUser.export_allowed = "1"
            }
            
            if !dictUserInfo["AddedUserFor"] == NSNull() {
                appDelegate.objCurrentUser.addedUserFor = dictUserInfo["AddedUserFor"]
            } else {
                appDelegate.objCurrentUser.addedUserFor = ""
            }
            if !dictUserInfo["white_label_logo"] == NSNull() {
                appDelegate.objCurrentUser.white_label_logo = dictUserInfo["white_label_logo"]
            } else {
                appDelegate.objCurrentUser.white_label_logo = nil
            }
            
            if !dictUserInfo["profileImage"] == NSNull() {
                appDelegate.objCurrentUser.profileImage = dictUserInfo["profileImage"]
            } else {
                appDelegate.objCurrentUser.profileImage = nil
            }
            if !dictUserInfo["hierarchy"] == NSNull() {
                appDelegate.objCurrentUser.seeFullHeirarchy = dictUserInfo["hierarchy"]
            } else {
                appDelegate.objCurrentUser.seeFullHeirarchy = "0"
            }
            
            if !dictUserInfo["ispeech_library"] == NSNull() {
                appDelegate.objCurrentUser.iSpeechLibrary = dictUserInfo["ispeech_library"]
            } else {
                appDelegate.objCurrentUser.iSpeechLibrary = "1"
            }
            if !dictUserInfo["default_lead_type"] == NSNull() {
                appDelegate.objCurrentUser.leadRetrivalSetting = dictUserInfo["default_lead_type"]
            } else {
                appDelegate.objCurrentUser.leadRetrivalSetting = "0"
            }
            
            if !dictUserInfo["allowed_lead_type"] == NSNull() {
                appDelegate.objCurrentUser.allowed_lead_type = dictUserInfo["allowed_lead_type"]
            } else {
                appDelegate.objCurrentUser.allowed_lead_type = "0"
            }
            if !dictUserInfo["startupTutEnable"] == NSNull() {
                appDelegate.objCurrentUser.startupTutEnable = dictUserInfo["startupTutEnable"]
            } else {
                appDelegate.objCurrentUser.startupTutEnable = "1"
            }
            
            if !dictUserInfo["eventTutEnable"] == NSNull() {
                appDelegate.objCurrentUser.eventTutEnable = dictUserInfo["eventTutEnable"]
            } else {
                appDelegate.objCurrentUser.eventTutEnable = "1"
            }
            if !dictUserInfo["RegisteredEventid"] == NSNull() {
                appDelegate.objCurrentUser.registeredEventId = dictUserInfo["RegisteredEventid"]
            } else {
                appDelegate.objCurrentUser.registeredEventId = ""
            }
            //Google
//            if !dictUserInfo["GoogleSpeechAPIKey"] == NSNull() {
//                var pref = UserDefaults.standard
//                pref.set(dictUserInfo["GoogleSpeechAPIKey"], forKey: "GoogleSpeechAPIKey")
//                pref.synchronize()
//            } else {
//                var pref = UserDefaults.standard
//                pref.set("", forKey: "GoogleSpeechAPIKey")
//                pref.synchronize()
//            }
            // added for popup message schedual tasks and Meeting
//            if !dictUserInfo["hasnotification"] == NSNull() {
//                appDelegate.objCurrentUser.hasnotification = dictUserInfo["hasnotification"]
//            } else {
//                appDelegate.objCurrentUser.hasnotification = ""
//            }
//            if !dictUserInfo["hastodaytask"] == NSNull() {
//                appDelegate.objCurrentUser.hastodaytask = dictUserInfo["hastodaytask"]
//            } else {
//                appDelegate.objCurrentUser.hastodaytask = ""
//            }
//            if !dictUserInfo["hastodaymeeting"] == NSNull() {
//                appDelegate.objCurrentUser.hastodaymeeting = dictUserInfo["hastodaymeeting"]
//            } else {
//                appDelegate.objCurrentUser.hastodaymeeting = ""
//            }
            //"business":"PHP Project Leader"
            addUserIfNotAvailable(appDelegate.objCurrentUser)
        }
    }
}


————————
func addUserIfNotAvailable(_ objUser: MleadUser?) {
    if !appDelegate.objSqliteDatabase.checkUser(by: objUser?.createTimeStamp) {
        appDelegate.objSqliteDatabase.insertRegistration(toDatabase: objUser)
    } else {
        appDelegate.objSqliteDatabase.updateUserFullProfile(objUser)
    }
}*/


