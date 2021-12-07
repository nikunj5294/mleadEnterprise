//
//  AppDelegate.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 04/04/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import LinkedinSwift
import Firebase
import IQKeyboardManagerSwift
import GoogleMaps


let USERDEFAULTS = UserDefaults.standard
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let app = (UIApplication.shared)
var navigationController: UINavigationController!

var alertbtnColor = Utilities.alertButtonColor()
var objLoginUserDetail : UserDetail!

var userInfoPath = String()
var databasePath = String()

var imgDocPath = String()
var soundDocPath = String()
var documentDir = String()

var MyApplicationID = "MLeads Enterprise"
var MyPassword = "vnOnwb0EOL+fyZCOkX9JJGPQ"

struct IndustryId {
    var IndustryID = [String]()
    var Industry = [String]()
}

struct CurrencyId {
    var CurrencyId = [String]()
    var Currency = [String]()
    var Symbol = [String]()
    var Hex_Symbol = [String]()
}

struct LeadRetrivelId{
    var LeadRetrivelID = [String]()
    var LeadRetrivel = [String]()
}

struct Status{
    var StatusId = [String]()
    var StatusName = [String]()
}

struct TeamMembers{
    var Name = NSArray()
    var CreatedTimeStemp = NSArray()
}

struct EventsWithin {
    var typeID = [String]()
    var duration = [String]()
}

struct Priority{
    var PriorityId = [String]()
    var PriorityName = [String]()
}


var arrWithinEvents : EventsWithin = EventsWithin.init(typeID: ["8","7","6","5","4","3","2","1","17","9","10","11","12","13","14","15","16"],
                                                       duration: ["Older Than 1 Year",
                                                                  "Past 12 Months",
                                                                  "Past 9 Months",
                                                                  "Past 6 Months",
                                                                  "Past 3 Months",
                                                                  "Past 1 Month",
                                                                  "Past 2 Weeks",
                                                                  "Past Week",
                                                                  "Today",
                                                                  "Next Week",
                                                                  "Next 2 Weeks",
                                                                  "Next 1 Month",
                                                                  "Next 3 Months",
                                                                  "Next 6 Months",
                                                                  "Next 9 Months",
                                                                  "Next 12 Months",
                                                                  "More Than 1 Year"])

var arrIndustryId : IndustryId = IndustryId.init(IndustryID: ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","20","21","22","23","24","25","26","29","30","31","32","33","19","28","27"],
                                                 Industry: ["Accounting","Air Transportation","Architect","Banking","Business Services","Construction","Consulting","Credit Unions","Debt Settlement/Loan Modification","Education","Equipment Leasing","Financial Services","Government","Healthcare/Medical","HR Staffing","Individual","Insurance","Legal","Not For Profit","Real Estate - Agent","Real Estate - Broker/Owner","Real Estate - Commercial","Real Estate - Mortgage","Real Estate - Property Management","Retail","Technology","Telecommunications","Travel & Leisure","Utilities","Other","Manufacturing","Staffing","Science/Life Science "])


var arrLeadRetrivel : LeadRetrivelId = LeadRetrivelId.init(LeadRetrivelID:["0","1","2","3","4","5","6","7","8","9","10"],
                                                           LeadRetrivel:["None","Scan Business Card","Scan the Badge","Speak","Scan QR Code","Bump Lead","Quick Lead","Quick Note","Type Lead"])

var arrStatus:Status = Status.init(StatusId: ["1","2","3","4"], StatusName: ["In-Progress","Completed","Waiting","Deferred"])

var arrPriority:Priority = Priority.init(PriorityId: ["1","2","3"], PriorityName: ["Normal","High","Low"])

var arrCurrencySupport: CurrencyId = CurrencyId.init(CurrencyId: ["106","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","1","107","108","109","110","111","112"],
                                                     Currency: ["Albania","Afghanistan","Argentina","Aruba","Australia","Azerbaijan","Bahamas","Barbados","Belarus","Belize","Bermuda","Bolivia","Bosnia and Herzegovina","Botswana","Bulgaria","Brazil","Brunei","Cambodia","Canada","Cayman","Chile","China","Colombia","Costa Rica","Croatia","Cuba","Czech Republic","Denmark","Dominican Republic","East Caribbean","Egypt","El Salvador","Estonia","Euro Member","Falkland Islands","Fiji","Ghana","Gibraltar","Guatemala","Guernsey","Guyana","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Isle of Man","Israel","Jamaica","Japan","Jersey","Kazakhstan","Korea (North)","Korea (South)","Kyrgyzstan","Laos","Latvia","Lebanon","Liberia","Lithuania","Macedonia","Malaysia","Mauritius","Mexico","Mongolia","Mozambique","Namibia","Nepal","Netherlands","New Zealand","Nicaragua","Nigeria","Norway","Oman","Pakistan","Panama","Paraguay","Peru","Philippines","Poland","Qatar","Romania","Russia","Saint Helena","Saudi Arabia","Serbia","Seychelles","Singapore","Solomon Islands","Somalia","South Africa","Sri Lanka","Sweden","Switzerland","Suriname","Syria","Taiwan","Thailand","Trinidad and Tobago","Turkey","Tuvalu","Ukraine","United Kingdom","United States","Uruguay","Uzbekistan","Venezuela","Viet Nam","Yemen","Zimbabwe"],
                                                     Symbol: ["USD","AFN","ARS","AWG","AUD"],
                                                     Hex_Symbol: ["$","","$","Æ","$"])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GMSServices.provideAPIKey("AIzaSyDgYvh45eoU_cGIHU_C3Q-Qwi2ZmpzaSY0")

        
        //FIREBASE CONFIGURE
        FirebaseApp.configure()
        
        //UDID
        if USERDEFAULTS.object(forKey: DEVICE_ID) == nil{
            let UUID = UIDevice.current.identifierForVendor!.uuidString
            USERDEFAULTS.set(UUID, forKey: DEVICE_ID)
            USERDEFAULTS.synchronize()
            print("DeviceID\(UUID)")
        }
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor(hexString: "#03A8F6")
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if UserDefaults.standard.object(forKey: isAppLaunchedFirstTime) == nil {
            self.showImageTutorialView()
        }
        
        //FileManager & DataBase...
        let fileManager = FileManager.default
        let arrFileSys = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        documentDir = arrFileSys[0]
        databasePath = URL(fileURLWithPath: documentDir).appendingPathComponent("MLeadAppDb.sqlite").absoluteString
        userInfoPath = URL(fileURLWithPath: documentDir).appendingPathComponent("UserDataInfo.plist").absoluteString
        let pref = UserDefaults.standard
        
//        if USERDEFAULTS.value(forKey: "FreeTrialAlert") == nil {
//            UserDefaults.standard.value (forKey: "FreeTrialAlert") = "NO"
//
//        }
        if !fileManager.fileExists(atPath: databasePath) {
            let strResourceCopy = Bundle.main.path(forResource: "MLeadAppDb", ofType: "sqlite")
            do {
                try fileManager.copyItem(atPath: strResourceCopy ?? "", toPath: databasePath)
            } catch {
            }
        }
        //objSqliteDatabase.initializedTable()

        IQKeyboardManager.shared.enable = true
        
        return true
    }
    //MARK:- ImageTutorial Function
    func showImageTutorialView(){
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LaunchViewController")
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        UserDefaults.standard.set(true, forKey: isAppLaunchedFirstTime)
    }
    
    //MARK:- validation Get Text...
    func getTextFrom(_ strString: String?) -> String? {
        var strTemp = ""
        if strString != nil{
            if (strString?.trimmingCharacters(in: CharacterSet.whitespaces).count)! > 0 {
                strTemp = (strString?.trimmingCharacters(in: CharacterSet.whitespaces))!
                return strTemp
            }
        }
//        if !(strString == NSNull()) {
//            if (strString?.trimmingCharacters(in: CharacterSet.whitespaces).count ?? 0) > 0 {
//                strTemp = strString?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
//                return strTemp
//            }
//        }
        return strTemp
    }
    
    //MARK:- DidRegister NotificationSetting
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        USERDEFAULTS.set(token, forKey: DEVICE_TOKEN)
        USERDEFAULTS.synchronize()
        print("Device Token :: \(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        let alertMessage = userInfo["aps"] as! NSDictionary
        let message = alertMessage.value(forKey: "alert") as! String
        print("Alert Message :: \(message.HTMLtoNormalString())")
        
        let alert = UIAlertController(title: "", message:  message.HTMLtoNormalString(),  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "Alert")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(OKAction)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if (url.scheme?.hasPrefix("fb"))!
        {
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else if (url.scheme?.hasPrefix("com.google"))!
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else if (url.scheme?.hasPrefix("li"))!
        {
            //return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return false
    }
    
    //DATABASE FILE..
    func copyUserFileToDocument() {
            var error: Error?
            //imgDocPath = URL(fileURLWithPath: documentDir).appendingPathComponent("Images").absoluteString
            //soundDocPath = URL(fileURLWithPath: documentDir).appendingPathComponent("Sound").absoluteString
            userInfoPath = URL(fileURLWithPath: documentDir).appendingPathComponent("UserDataInfo.plist").absoluteString

            let fileManager = FileManager.default

            if !fileManager.fileExists(atPath: imgDocPath) {
                do {
                    try fileManager.createDirectory(atPath: imgDocPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                }
            }
            if !fileManager.fileExists(atPath: soundDocPath) {
                do {
                    try fileManager.createDirectory(atPath: soundDocPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                }
            }
            if !fileManager.fileExists(atPath: userInfoPath) {
                let bundle = Bundle.main.path(forResource: "UserDataInfo", ofType: "plist")
                do {
                    try fileManager.copyItem(atPath: bundle ?? "", toPath: userInfoPath)
                    } catch {
                }
            }else {
                var dictUserInfo = NSDictionary(contentsOfFile: userInfoPath) as Dictionary?
                let dictNewInfo = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "User_info", ofType: "plist") ?? "") as Dictionary?
//                if !(dictNewInfo?["dbVersion"] == dictUserInfo["dbVersion"]) as? Dictionary{
//                    dictUserInfo!["dbVersion"] = dictNewInfo?["dbVersion"] as String
//                    if let dictUserInfo = dictUserInfo {
//                        (dictUserInfo as NSDictionary).write(toFile: userInfoPath, atomically: true)
//                }
//            }
        }
    }
}

