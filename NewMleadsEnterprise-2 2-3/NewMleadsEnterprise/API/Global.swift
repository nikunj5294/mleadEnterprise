//
//  Global.swift
//  Wreckers
//
//  Created by MAC-1 on 28/01/20.
//  Copyright © 2020 MAC-1. All rights reserved.
//

import UIKit

var ScreenWidth = UIScreen.main.bounds.width
var ScreenHeight = UIScreen.main.bounds.height
var ScreenScale = ScreenWidth/320
var appdelegate = UIApplication.shared.delegate as! AppDelegate
var GoogleAPIKey = "AIzaSyCRhkqIYZGG0G8IpIyEhsg8FO43npvDd3k"//"AIzaSyAVAZWAK8i7CaVtI0V9CeP6OQX4oKDiVww"
var glbLatitude = 23.2156
var glbLongitude = 72.6369
var glbNotificationCount = String()

var fromTabBar : Bool?

struct StoryBoard
{
    static let Login = UIStoryboard(name: "Login", bundle: nil)
    
    static let CustomAlert = UIStoryboard(name: "CustomAlert", bundle: nil)
    static let MyLead = UIStoryboard(name: "MyLead", bundle: nil)
}

let userdefault = UserDefaults.standard

var glbUserID = ""
var glbAuthToken = ""
var glbUserName = ""
var glbUserEmail = ""
var glbFullName = ""
var glbProfilePic = ""
var glbDeviceToken = "123456"
var glbDeviceID = ""
var glbDeviceType = "ios"
var glbDeviceName = ""



var DEVICE_ID = "iPhoneUniqueID"
var DEVICE_TYPE = "ios"
var DEVICE_TOKEN = "DeviceToken"
var LOGIN_USER_Detail = "LoginUserDetail"
var IS_ALREADY_LOGIN = "isAlreadyLogin"
var IS_SHOW_SUBSCRIPTION_DIALOG = "isShowSubscriptionDialog"
var IS_LOGIN_SUCCESSFUL = "isLoginSuccessful"
var LOGIN_ID = "UserLoginID"
var isAppLaunchedFirstTime = "isAppLaunchedFirstTime"
var kIsLoginSuccessful = "isLoginSuccessful"
var LOGIN_NOTIFICATION = "checkAuth"

var REGISTRATION_NOTIFICATION = "doRegistration"
var USER_TYPE_FOR_APP = "E"
var BUSINESS_USER_TYPE = "S"

//LOCAL SERVER
//var WEBSERVICE_URL                                  @"http://192.168.1.51/mleads9.6/MLeads9.7.19/"
//var MY_DASHBOARD_URL                                @"https://www.myleadssite.com/dashboardmobile.php?userId="
//var     ReportURL                                   @"http://192.168.1.51/mleads9.6/reports/"


//LIVE Server
var WEBSERVICE_URL  = "https://www.myleadssite.com/MLeads9.7.22/"
var MY_DASHBOARD_URL  = "https://www.myleadssite.com/dashboardmobile.php?userId="
var ReportURL  = "https://www.myleadssite.com/reports/"
var GET_COUNTRY_FROM_IP_ADDRESS  = "http://api.codehelper.io/ips/"
var LOGIN_API_URL  = "getLogin.php"
var REGISTRATION_API_URL  = "registerFreeTrialEnterpriseUser.php"
var LOGINDEVICERESPONSE_API_URL  = "getRegisterDevice.php"
var FORGOT_PASSWORD_API_URL  = "getForgotPassword.php"
var GET_FORGOT_PASSWORD_EMAIL  = "getForgotPasswordEmail.php"
var RESET_PASSWORD_API_URL  = "getChangePassword.php"
var GET_USER_DETAIL  = "getUserDetail.php"
var GET_ADD_PUSHNOTIFICATION  = "getAddPushNotification.php"
var LOGOUT_API_URL  = "getUnRegisterDevice.php"
var GET_ADD_TEAM_MEMBER_API_URL  = "registerFeeTrialAddTeamMember.php"
var GET_ADD_TEAM_MEMBER_LIST  = "getAddTeamMemberList.php"
var GET_NOT_SHARED_LEAD_LIST  = "getNotSharedLeadList.php"
var GET_SHARED_LEAD_LIST  = "getSharedLeadList.php"
var UPDATE_USER_API_URL  = "updateUser.php"
var SUBMIT_REQUEST_FOR_DEMO_API  = "addRequestDemo.php"
var DELETE_TEAM_MEMBER_API_URL  = "deleteTeamMember.php"
var TRANSFER_TEAM_MEMBER_API_URL  = "transferTeamMember.php"
var GET_EVENT_COUNT  = "getEventCount.php"
var ADD_MEETING_API_URL  = "getAddMeeting.php"
var GET_MEETING_LIST_API_URL  = "getMeetingList.php"
var GET_SALESOPPORTUNITY_LIST_API_URL  = "getOpprtunityList.php"
var GET_TASK_LIST_API_URL  = "getTaskList.php"
var getLeadFollowup_LIST_API_URL  = "getLeadFollowup.php"
var DELETE_TASK_API_URL  = "getDeleteTask.php"
var ADD_TASK_API_URL  = "getAddTask.php"
var UPDATE_TASK_API_URL  = "updateTask.php"
var GET_EVENTLIST_ENTERPISE_WITHIN_URL  = "getEventListwithin_Enterprise.php"
var GET_EVENTLIST_ENTERPISE_URL  = "getEventList_Enterprise_iphone.php"
var ADD_LEAD_POST_URL  = "getAddLeadPost.php"
var DELETE_LEAD_API_URL  = "getDeleteLead.php"
var GET_ALL_EVENT_API_URL  = "getEventList.php"
var GET_REGISTER_EVENTS_WITHIN_URL  = "getRegisteredEvents.php"
var ADD_EVENT_API_URL  = "getAddEvent.php"
var EDIT_EVENT_API_KEY  = "updateEvent.php"
var DELETE_EVENT_BY_ID_API_URL  = "getDeleteEvent.php"
var Get_GroupDetails_By_Id_URL  = "getLeadGroupDetail.php"
var Add_LeadGroup_API_URL  = "getAddLeadGroup.php"
var GET_ALL_GROUPLIST_URL  = "getLeadGroupListWithin.php"
var UploadProfileAndWhiteLogo  = "getUploadLogo.php"
var GET_LEADLIST_ENTERPISE_URL  = "getLeadList_Enterprise_new.php"
var GET_SCHEDULED_TASKS_URL  = "getTaskListLastTwoWeekEnterprice.php"
var GET_SCHEDULED_MEETINGS_URL  = "getMeetingListLastTwoWeekEnterprice.php"
var GET_TASK_DETAIL_API_URL  = "getTaskDetail.php"
var GET_MEETING_DETAIL_API_URL  = "getMeetingDetail.php"
var GET_PipeLine_Sales_Report  = "pipelinesales.php?userId="
var GET_Sales_Report  = "salesreport.php?userId="
var Sales_Cycle_Report_API_URL  = "salesCycleReport.php"
var GET_LeadByLead_Qualifire_Report  = "leadsreport.php?eventId="

var Get_EmailTamplate_API = "getEmailTemplate.php"
var GET_EventList_For_User_Api = "getUserEventWiseLeadList.php"
var CSV_NEW_LINE_INDICATOR = "\n"
var GET_VideoProfile_Link_URL = "getVideoLinks.php"
var GET_ExportAbility_API_URL = "updateExportAbility.php"
var GET_EMAIL_STATISTICS_URL = "getEmailstatistics.php"
var GET_EVENTLIST_ENTERPISE_URL_TESTING = "getEventListwithin_Enterprise_android.php"
var GET_LEAD_BYMAP_KEY  = "getLeadByMap.php"
var GET_LEAD_BY_ID_API_URL = "getLeadDetail.php"

var EDIT_LEAD_API_URL = "updateLeadPost.php"
var GET_LEADLIST_EVENTWISE  = "getEventWiseLeadList.php"
var GET_ADDSHAREDLEAD  = "getAddShareLead.php"
var UN_SHARE_LEAD  = "unshareLead.php"
var TRANFER_LEADS  = "getTransferLead.php"

//Ajay
struct AppColor {
    static let Color234_236_236 = UIColor.init(named: "234_236_236_Color")!
}

//MARK: Methods

func roundToTens(x : Double) -> Int {
    var i = Int(floor(x / 10.0))
    let text = Int(x - (floor(x / 10.0) * 10))
    if x == 0
    {
        i = i+1
    }
    else if text != 0
    {
        i = i+1
    }
    return 10 * i
}

func ToString(_ StingText : Any?) -> String
{
    if let strText = StingText
    {
        if let TempString = strText as? String
        {
            return TempString
        }
        else if let TempFloat = StingText as? Float
        {
            return String(TempFloat)
        }
        else if let TempDouble = StingText as? Double
        {
            return String(TempDouble)
        }
        else if let TempNumber = strText as? NSNumber
        {
            return TempNumber.stringValue
        }
        else if let TempNumber = strText as? Int
        {
            return String(TempNumber)
        }
        else if let TempNumber = strText as? NSURL, let urlToString = TempNumber.absoluteString
        {
            return urlToString
        }
        
        return "\(strText)"
    }
    else
    {
        return ""
    }
}

func ToInt(_ StrText : Any?) -> Int
{
    let sttTemp = ToString(StrText)
    if let myInteger = Int(sttTemp)
    {
        return myInteger
    }
    return 0
}

func checkValidString(_ CheckString : String?) -> Bool
{
    if let strTemp = CheckString
    {
        return  !(strTemp.isEmpty || strTemp == "" || strTemp == "(null)" || strTemp == " " ||  strTemp.trimmingCharacters(in: .whitespaces).count == 0)
    }
    else
    {
        return false;
    }
}

func isValidEmail(_ testStr:String?) -> Bool
{
//    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
    "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isValidPassword(_ testStr:String?) -> Bool
{
    let passLowerCase = "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*?[0-9]).*"
    // "^(?=.{8,15}$)(?=.*?[A-Za-z0-9])(?=.*[$@$#!%*?&'^<>])(?=.*?[\\W_])[\\w\\W]+" // For Symbols

    let passTest = NSPredicate(format:"SELF MATCHES %@", passLowerCase)
    
    return passTest.evaluate(with: testStr)
}

func ShowAlert(title:String?, message:String?, buttonTitle:String,handlerCB:(()->())?) {
    
    DispatchQueue.main.async {
        let Alert:UIAlertController = UIAlertController(title: title?.count == 0 ? "Mleads" : title, message: message, preferredStyle: UIAlertController.Style.alert)
        Alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { (action) in
            handlerCB?()
        }))
        if let topVC = UIApplication.getTopViewController() {
            topVC.present(Alert, animated: true, completion: nil)
        }
    }
}

func ShowAlert2Options(title:String?, message:String?, buttonTitle1:String, buttonTitle2:String,handlerCB1:(()->())?, handlerCB2:(()->())?) {
    
    DispatchQueue.main.async {
        let Alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        Alert.addAction(UIAlertAction(title: buttonTitle1, style: UIAlertAction.Style.default, handler: { (action) in
            handlerCB1?()
        }))
        Alert.addAction(UIAlertAction(title: buttonTitle2, style: UIAlertAction.Style.default, handler: { (action) in
            handlerCB2?()
        }))
        appdelegate.window?.rootViewController?.present(Alert, animated: true, completion: nil)
    }
}


func ConvertToBool(_ StrText : Any?) -> Bool
{
    switch ToString(StrText)
    {
    case "True", "true", "yes", "1.0", "1":
        return true
    case "False", "false", "no", "0.0", "0":
        return false
    default:
        return false
    }
}

func replaceBlankTo_(str: String) -> String
{
    let strNew = str.replacingOccurrences(of: " ", with: "_")
    return strNew
}


//MARK: User Defaults
func removeAllUserDefaults()
{
    glbUserEmail = ""
    glbUserName = ""
    glbUserID = ""
    glbAuthToken = ""
    glbFullName = ""
    glbProfilePic = ""

//    STPCustomerContext.clearCache(<#T##self: STPCustomerContext##STPCustomerContext#>)
    WebServiceCH.shared.removeAuthorizationToken()
 
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
}

func setUserDefault(_ params:AnyObject, Key: String)
{
    let data = NSKeyedArchiver.archivedData(withRootObject: params)
    UserDefaults.standard.setValue(data, forKey: Key)
}

func getUserDefault(Key:String) -> AnyObject
{
    if let data = UserDefaults.standard.value(forKey: Key) as? Data {
        if let storedData = NSKeyedUnarchiver.unarchiveObject(with: data){
            return storedData as AnyObject
        }
    }
    return NSNull()
}

//MARK: Global Date Methods
func dateConvert_Global(date:String,ToFormate:String,GetFormate:String) -> String {
        
    let formatter = DateFormatter()
    formatter.dateFormat = ToFormate // Formate Get from Response
    let yourDate: Date? = formatter.date(from: date)
    formatter.dateFormat = GetFormate // WhitchFormate u  have convert
    formatter.timeZone = NSTimeZone.system
    return formatter.string(from: yourDate!)
}

func dateConvert_GlobalUTCToLocal(date:String,ToFormate:String,GetFormate:String) -> String {
    
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.init(identifier: "UTC")
    formatter.dateFormat = ToFormate // Formate Get from Response
    let yourDate: Date? = formatter.date(from: date)
    formatter.dateFormat = GetFormate // which Formate u have to convert
    formatter.timeZone = NSTimeZone.system
    return formatter.string(from: yourDate!)
}

func dateConvert_GlobalToDate(date:String,ToFormate:String,GetFormate:String) -> Date {
        
    let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(identifier: "UTC")
    formatter.dateFormat = ToFormate // Formate Get from Response
//    formatter.timeZone = NSTimeZone.system
    let yourDate: Date? = formatter.date(from: date)
    return yourDate!
}

func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
    let calendar = NSCalendar.current

    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let components : DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: now as Date)
    
    if (components.year! >= 2) {
        return "\(String(describing: components.year!)) \("years ago")"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(String(describing: components.month!)) \("months ago")"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(String(describing: components.weekOfYear!)) \("weeks ago")"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(String(describing: components.day!)) \("days ago")"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(String(describing: components.hour!)) \("hours ago")"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(String(describing: components.minute!)) \("minutes ago")"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(String(describing: components.second!)) \("seconds ago")"
    } else {
        return "Just now"
    }
}


extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
