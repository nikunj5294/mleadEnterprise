//
//  HandleWebService.swift
//
//
//  Created by Ashish Salet on 7/5/19.
//  Copyright © 2016 Tri-Force Consulting Services. All rights reserved.
//

import UIKit
import Foundation
import SSKeychain

open class HandleWebService:NSObject
{
    var appdelegate = AppDelegate()
    
    //MARK:- Login Funciton
    open func handleLogin(_ response:Data) -> (Status:Bool,UserId:String)
    {
        var isStatus:Bool = false
        var userId = String()
        
        let json = JSON(data: response)
        
       //if json["status"].string == "YES"
        if json["userLogin"]["status"].string == "YES"
        {
            
            let Logindata = json["userLogin"]
            userId = Logindata["userId"].string!
            
//            var uId : Int  = json["userLogin"]["userId"].int!
//            userId = String(uId)
            print("User ID  Print \(userId)")
            isStatus = true
        }
        
        return (isStatus,userId)
    }
    
    //MARK:- User Details Function
    
    open func handleUserDetails(_ response:Data) -> (Status:Bool,UserDetail:UserDetail)
    {
        var isStatus:Bool = false
        let objuserDetail:UserDetail = UserDetail()
        
        let json = JSON(data: response)
        let result = json["userDetail"] //userDetail    //userDetail
        
        if result["status"].string == "YES"
        {
            let UserDetail = result["userInfoArr"] //userInfoArr
            
            objuserDetail.userId = UserDetail["userId"].string
            objuserDetail.firstName = UserDetail["firstName"].string
            objuserDetail.lastName = UserDetail["lastName"].string
            objuserDetail.userName = UserDetail["userName"].string
            objuserDetail.password = UserDetail["password"].string
            objuserDetail.email = UserDetail["email"].string
            
            objuserDetail.createTimeStamp = UserDetail["createdTimeStamp"].string  //
            objuserDetail.updateTimeStamp = UserDetail["updatedTimeStamp"].string  //
            objuserDetail.userType = UserDetail["userType"].string  //
            objuserDetail.companyName = UserDetail["companyName"].string  //
            
            objuserDetail.address = UserDetail["address"].string  //
            objuserDetail.city = UserDetail["city"].string  //
            objuserDetail.state = UserDetail["state"].string//
            objuserDetail.zipCode = UserDetail["zipCode"].string  //
            objuserDetail.country = UserDetail["country"].string //
            //objuserDetail.phone = UserDetail["phone"].string  //
            objuserDetail.phone = UserDetail["phoneNumber"].string  ///
            objuserDetail.mobile = UserDetail["mobilePhone"].string ///
            
            objuserDetail.companyWebsite = UserDetail["companyWebSite"].string///
            //objuserDetail.securityQuesId = UserDetail["securityQuesId"].string
            objuserDetail.securityQuesId = UserDetail["securityQuesId"].string//
            objuserDetail.securityQues = UserDetail["securityQues"].string  //
            objuserDetail.securityAnswer = UserDetail["securityAnswer"].string//
            objuserDetail.hearAbout = UserDetail["hearFrom"].string   //hearAbout key
            objuserDetail.report = UserDetail["reportsTo"].string ///
            objuserDetail.eventOrganizer = UserDetail["event_organizer_type"].string //
            
            //objuserDetail.companySite = UserDetail["companySite"].string
            objuserDetail.industryId = UserDetail["industryId"].string
            objuserDetail.registerType = UserDetail["registerType"].string
            objuserDetail.mobilePlatfrom = UserDetail["mobilePlatfrom"].string
            objuserDetail.ip = UserDetail["ip"].string //
            objuserDetail.currency_id = UserDetail["currency_id"].string //
            
            objuserDetail.phoneExt = UserDetail["phoneExt"].string
            objuserDetail.otherPhone = UserDetail["otherPhone"].string
            objuserDetail.isOptInCheck = (UserDetail["isOptInCheck"].string != nil)
            objuserDetail.jobTitle = UserDetail["jobtitle"].string       //jobTitle
            objuserDetail.currencySupport = UserDetail["currencySupport"].string
            objuserDetail.optIn = UserDetail["optIn"].string
            
            objuserDetail.export_allowed = UserDetail["export_allowed"].string
            objuserDetail.AddedUserFor = UserDetail["AddedUserFor"].string
            objuserDetail.white_label_logo = UserDetail["white_label_logo"].string
            objuserDetail.profileImage = UserDetail["profileImage"].string
            objuserDetail.seeFullHeirarchy = UserDetail["seeFullHeirarchy"].string
            
            objuserDetail.signature = UserDetail["signature"].string
            objuserDetail.iSpeechLibrary = UserDetail["iSpeechLibrary"].string
            objuserDetail.leadRetrivalSetting = UserDetail["leadRetrivalSetting"].string
            objuserDetail.allowed_lead_type = UserDetail["allowed_lead_type"].string
            objuserDetail.startupTutEnable = UserDetail["startupTutEnable"].string
            
            objuserDetail.eventTutEnable = UserDetail["eventTutEnable"].string
            objuserDetail.registeredEventId = UserDetail["registeredEventId"].string
            objuserDetail.hasnotification = UserDetail["hasnotification"].string
            objuserDetail.hastodaytask = UserDetail["hastodaytask"].string
            objuserDetail.hastodaymeeting = UserDetail["hastodaymeeting"].string
            
            isStatus = true
        }
        
        return (isStatus,objuserDetail)
    }
    
    
    
    //MARK:- SignUp
    open func handleSignUp(_ response:Data) -> (Status:Bool,UserId:String)//,CreateTimeStamp:String)
    {
        var isStatus:Bool = false
        var userId = String()
        //var createTimeStamp = String()
        let json = JSON(data: response)
        
        
        print(json)
        
        //if json["status"].string == "YES"
        if json["registerFreeEnterpriserUser"]["status"].string == "YES"
        {
            //let signupData = json["userDetail"]
            let uId : Int  = json["registerFreeEnterpriserUser"]["userId"].int!
            userId = String(uId)
            //createTimeStamp = signupData["createdTimeStamp"].string!
            
            isStatus = true
        }
        return (isStatus,userId)
    }
    
    
    //MARK:- Forget Password
    open func handleForgotPassword(_ response:Data) -> Bool
    {
        var isStatus:Bool = false
        
        let json = JSON(data: response)
        if json["status"].string == "YES"
        {
            isStatus = true
        }
        
        return isStatus
    }
    
    
    open func handleForgotPasswordEmail(_ response:Data) -> Bool
    {
        var isStatus:Bool = false
        let json = JSON(data: response)
        if json["status"].string == "YES"
        {
            isStatus = true
        }
        
        return isStatus
    }
    
    open func handleResetPassword(_ response:Data)-> Bool
    {
        var isStatus:Bool = false
        
        let json = JSON(data: response)
        if json["status"].string == "YES"
        {
            isStatus = true
        }
        
        return isStatus
    }
    
    //MARK:- Email Statiscs Response...
    open func handleGetEmailStatiscs(_ response:Data) -> (Status: Bool, teamMember: [UserDetail], arrEventL: NSMutableArray)
    {
        var isStatus:Bool = false
        var arrTeamMember = [UserDetail]()
        let arrAllEvents = NSMutableArray()
        let json = JSON(data: response)
        
        if json["getEmailstatistics"]["status"].string == "YES"
        {
            let eventArr = json["getEmailstatistics"]["getEmailstatistics"]
            for i in 0..<eventArr.count
            {
                let arrEvent = eventArr[i]
                
                //MARK: TeamMEmber Data..
                let userDetailArr = arrEvent["userDetailsArr"]
                print(userDetailArr)
                let teamMember: UserDetail = UserDetail()
                teamMember.userId = userDetailArr[ "id"].string
                teamMember.firstName = userDetailArr[ "first_name"].string
                teamMember.userName = userDetailArr[ ""].string
                teamMember.lastName = userDetailArr[ "last_name"].string
                teamMember.email = userDetailArr[ "email"].string
                teamMember.companyName = userDetailArr[ "companyName"].string
                teamMember.report = userDetailArr[ "reportsTo"].string
                teamMember.createTimeStamp = userDetailArr[ "created_timestamp"].string
                teamMember.export_allowed = userDetailArr[ "export_allowed"].string
                
                arrTeamMember.append(teamMember)
                
                //MARK: Event Or Group Data...
                let tempEventListArr = arrEvent["events"]
                if tempEventListArr == nil
                {
                    for j in 0..<tempEventListArr.count
                    {
                        let tempEvent = tempEventListArr[j]
                        let arrEventList = tempEvent["mailstArray"]
                        let arrLeadOfList = NSMutableArray()
                        let leadType = String()
                        
                        
                    }
                }
            }
            isStatus = true
        }
        return(isStatus,arrTeamMember, arrAllEvents)
    }
    
    //MARK:- My Lead List
    func handleGetEventList(_ response: Data) -> (Status: Bool, teamMember: [UserDetail], arrEventL: NSMutableArray)
    {
        var isStatus:Bool = false
        var arrTeamMember = [UserDetail]()
        let arrAllEvents = NSMutableArray()
        let json = JSON(data: response)
        
        if json["eventList"]["status"].string == "YES"
        {
            let eventArr = json["eventList"]["eventArr"]
            for i in 0..<eventArr.count
            {
                //TeamMember
                let arrEvent = eventArr[i]
                let userDetailArr = arrEvent["userDetailArr"]
               // print(userDetailArr)
                let teamMember : UserDetail = UserDetail()
                teamMember.userId = userDetailArr["id"].string
                teamMember.firstName = userDetailArr["first_name"].string
                teamMember.userName = ""
                teamMember.lastName = userDetailArr["last_name"].string
                teamMember.email = userDetailArr["email"].string
                teamMember.companyName = userDetailArr["companyName"].string
                teamMember.companyWebsite = userDetailArr["companyWebSite"].string
                teamMember.report = userDetailArr["reportsTo"].string
                teamMember.createTimeStamp = userDetailArr["created_timestamp"].string
                //teamMember.AddedUserFor = userDetailArr["AddedUserFor"].string
                
                //Event List For TeamMember
                let tempArrEventList = arrEvent["eventArr"]
                //print(tempArrEventList)
                for j in 0..<tempArrEventList.count
                {
                    //let temp = tempArrEventList![j]
                    //let objEventList = json["eventList"]["eventArr"][j]
                    let objEventList = tempArrEventList[j]
                    let objEvent: EventDetail = EventDetail()
                    objEvent.eventName =  objEventList["eventName"].string
                    objEvent.eventid = objEventList["eventId"].string
                    objEvent.createdTimeStamp = objEventList["eventId"].string
                    objEvent.location = objEventList["location"].string
                    objEvent.city = objEventList["city"].string
                    objEvent.eventDate = objEventList["eventDate"].string
                    objEvent.Agenda = objEventList["Agenda"].string
                    
                    arrAllEvents.add(objEvent)
                }
                arrTeamMember.append(teamMember)
                
            }
            
            isStatus = true
        }
        print(arrTeamMember)
        print(arrAllEvents)
        return (isStatus, arrTeamMember, arrAllEvents)
    }
    
    //Comment in 18/6/2020
    func handleGetLeadList(_ response: Data) -> (Status: Bool, teamMember: [UserDetail], arrLeadList: NSMutableArray, arrDictList: NSMutableArray)
    {
        var isStatus:Bool = false
        var arrTeamMember = [UserDetail]()
        let arrAllEvents = NSMutableArray()
        let arrDict = NSMutableArray()
        let json = JSON(data: response)
        print(json)
        
        
        if json["getLeadList"]["status"].string == "YES"
        {
            let eventArr = json["getLeadList"]["eventLeadList"]
            for i in 0..<eventArr.count
            {
                let arrEvent = eventArr[i]
                let userDetailArr = arrEvent["userDetailArr"]
                let teamMember : UserDetail = UserDetail()
                
                teamMember.userId = userDetailArr["id"].string
                teamMember.firstName = userDetailArr["first_name"].string
                teamMember.userName = ""
                teamMember.lastName = userDetailArr["last_name"].string
                teamMember.email = userDetailArr["email"].string
                teamMember.companyName = userDetailArr["companyName"].string
                teamMember.companyWebsite = userDetailArr["companyWebSite"].string
                teamMember.report = userDetailArr["reportsTo"].string
                teamMember.createTimeStamp = userDetailArr["created_timestamp"].string
                teamMember.export_allowed = userDetailArr["export_allowed"].string
                
                let arrEventWiseLead = arrEvent["eventWiseLeadArr"]
                if arrEventWiseLead != nil
                {
                    for j in 0..<arrEventWiseLead.count
                    {
//                        let eventName = arrEventWiseLead[j]["eventName"]
//                        let eventId = arrEventWiseLead[j]["event_Id"]
//                        let eventDate = arrEventWiseLead[j]["eventDate"]
                        
                        let arrLeadList = arrEventWiseLead[j]["leadList"].array
                        //validation Check After Code. Baki 6e
                        var leadType = String()
//                        if arrEventWiseLead[j]["type"] != nil
//                        {
//                            leadType = (arrEventWiseLead[j]["type"] )
//                        }
                        for k in 0..<arrLeadList!.count
                        {
                            //let objleadList : LeadList = LeadList(attechmentArray: <#NSArray#>, deleteIDsArray: <#NSArray#>, product: <#NSArray#>)
                            let objLeadlist: LeadList = LeadList()
                            
                            objLeadlist.createTimeStamp = arrLeadList![k]["leadId"].string
                            objLeadlist.eventId = arrLeadList![k]["eventId"].string
                            objLeadlist.firstName = arrLeadList![k]["firstName"].string
                            objLeadlist.lastName = arrLeadList![k]["lastName"].string
                            objLeadlist.company = arrLeadList![k]["company"].string
                            objLeadlist.email = arrLeadList![k]["email"].string
                            objLeadlist.phone = arrLeadList![k]["phone"].string
                            objLeadlist.imgURL = arrLeadList![k]["photo_path"].string
                            objLeadlist.photo_path_thumbnail = arrLeadList![k]["photo_path_thumbnail"].string
                            
                            objLeadlist.leadStatus = arrLeadList![k]["lead_status"].string
                            objLeadlist.leadStatusName = arrLeadList![k]["leadStatusTitle"].string
                            objLeadlist.leadStatusURL = arrLeadList![k]["leadStatusUrl"].string
                            objLeadlist.leadId = arrLeadList![k]["leadId"].string
                            
                            objLeadlist.target = arrLeadList![k]["targerAmount"].string
                            objLeadlist.periods = arrLeadList![k]["periods"].string
                            objLeadlist.targetFuture = arrLeadList![k]["targetFutureAmount"].string
                            objLeadlist.targetClosing = arrLeadList![k]["tagetCloseDate"].string
                            objLeadlist.proOfClosing = arrLeadList![k]["probabilityClosePer"].string
                            objLeadlist.nextStepDate = arrLeadList![k]["nextStepDate"].string
                            objLeadlist.jobTitle = arrLeadList![k]["job_title"].string
                            
                            objLeadlist.notes = arrLeadList![k]["notes"].string
                            objLeadlist.otherPhone = arrLeadList![k]["other_phone"].string
                            objLeadlist.addedLeadType = arrLeadList![k]["addedLeadType"].string
                            objLeadlist.recordSoundUrl = arrLeadList![k]["recordSoundUrl"].string
                            objLeadlist.processBadge = arrLeadList![k]["process"].string
                            objLeadlist.followup_action_list = arrLeadList![k]["followup_action_list"].string
                            
                            //objLeadlist.product
                            
                            //objLeadlist.leadAddedType = leadType
                         
                            arrAllEvents.add(objLeadlist)
                        }
                        
                 // Dic For Event Name And Event Id And event Date Or LIST...
                        let arrEventName = arrEventWiseLead[j]["eventName"].string
                        let arrEventId = arrEventWiseLead[j]["event_Id"].string
                        let arrEventDate = arrEventWiseLead[j]["eventDate"].string
                        let dict  = NSMutableDictionary()
                        //var dic : [String : AnyObject] = arrEventWiseLead[j].dictionaryObject! as [String : AnyObject]
                        //dict.setObject(arrEventWiseLead[j]["eventName"], forKey: ["eventName"] as! String)
                     
                        dict.setValue(arrEventName, forKey: "eventName")
                        dict.setValue(arrEventId, forKey: "event_Id")
                        dict.setValue(arrAllEvents, forKey: "list")
                        dict.setValue(leadType, forKey: "type")
                        dict.setValue(arrEventDate, forKey: "eventDate")
                        
                        arrDict.add(dict)
                        print(arrDict)
                        //tempfile
                        // dic.setValue(arrAllEvents, forKey:arrEvents.object(at: j) as! String)
////                        //arrEvnt.add(dic)
                    }
                }
                arrTeamMember.append(teamMember)
                
            }
            isStatus = true
        }
        return (isStatus, arrTeamMember, arrAllEvents, arrDict)
    }
    func handleGetEventWiseLeadList(_ response: Data, isMessaging:Bool) -> (Status: Bool, arrLeadList: NSMutableArray)
    {
        var isStatus:Bool = false
        let arrAllEvents = NSMutableArray()
        let json = JSON(data: response)
        print(json)
        
        
        if json["getEventWiseLeadList"]["status"].string == "YES"
        {
            let eventInfo = json["getEventWiseLeadList"]["eventInfoLeadList"]["eventInfo"]
            let arrLeadList = json["getEventWiseLeadList"]["eventInfoLeadList"]["EventsLeads"].array
            for k in 0..<arrLeadList!.count
            {
                
                if isMessaging == false || isMessaging == true && arrLeadList![k]["phone"].string != nil && !arrLeadList![k]["phone"].string!.isBlank
                {
                    let objLeadlist: LeadList = LeadList()

                    objLeadlist.createTimeStamp = arrLeadList![k]["leadId"].string
                    objLeadlist.eventId = eventInfo["eventId"].string
                    objLeadlist.firstName = arrLeadList![k]["firstName"].string
                    objLeadlist.lastName = arrLeadList![k]["lastName"].string
                    objLeadlist.company = arrLeadList![k]["company"].string
                    objLeadlist.email = arrLeadList![k]["email"].string
                    objLeadlist.phone = arrLeadList![k]["phone"].string
                    objLeadlist.imgURL = arrLeadList![k]["photo_path"].string
                    objLeadlist.photo_path_thumbnail = arrLeadList![k]["photo_path_thumbnail"].string
                    
                    objLeadlist.leadStatus = arrLeadList![k]["lead_status"].string
                    objLeadlist.leadStatusName = arrLeadList![k]["leadStatusTitle"].string
                    objLeadlist.leadStatusURL = arrLeadList![k]["leadStatusUrl"].string
                    objLeadlist.leadId = arrLeadList![k]["leadId"].string
                    
                    objLeadlist.target = arrLeadList![k]["targerAmount"].string
                    objLeadlist.periods = arrLeadList![k]["periods"].string
                    objLeadlist.targetFuture = arrLeadList![k]["targetFutureAmount"].string
                    objLeadlist.targetClosing = arrLeadList![k]["tagetCloseDate"].string
                    objLeadlist.proOfClosing = arrLeadList![k]["probabilityClosePer"].string
                    objLeadlist.nextStepDate = arrLeadList![k]["nextStepDate"].string
                    objLeadlist.jobTitle = arrLeadList![k]["job_title"].string
                    
                    objLeadlist.notes = arrLeadList![k]["notes"].string
                    objLeadlist.otherPhone = arrLeadList![k]["other_phone"].string
                    objLeadlist.addedLeadType = arrLeadList![k]["addedLeadType"].string
                    objLeadlist.recordSoundUrl = arrLeadList![k]["recordSoundUrl"].string
                    objLeadlist.processBadge = arrLeadList![k]["process"].string
                    objLeadlist.followup_action_list = arrLeadList![k]["followup_action_list"].string
                    
                    //objLeadlist.product
                    
                    //objLeadlist.leadAddedType = leadType
                 
                    arrAllEvents.add(objLeadlist)
                }
                
            }
            isStatus = true
        }
        return (isStatus, arrAllEvents)
    }
    //
    func handleGetAddTeamMemberList(_ response: Data) -> (Status: Bool, arrTeamMember: [TeamMember])
    {
        var isStatus:Bool = false
        var arrAllTeamMember = [TeamMember]()
        let json = JSON(data: response)
        print(json)
        
        if json["AddTeamMember"]["status"].string == "YES"
        {
            let arrTeamMember = json["AddTeamMember"]["AddTeamMemberList"].array
            for k in 0..<arrTeamMember!.count
            {
                let objLeadlist: TeamMember = TeamMember()

                objLeadlist.first_name = arrTeamMember![k]["first_name"].string
                objLeadlist.last_name = arrTeamMember![k]["last_name"].string
                objLeadlist.reportsTo = arrTeamMember![k]["reportsTo"].string
                objLeadlist.created_timestamp = arrTeamMember![k]["created_timestamp"].string
                objLeadlist.export_allowed = arrTeamMember![k]["export_allowed"].string
             
                arrAllTeamMember.append(objLeadlist)
            }
            isStatus = true
        }
        return (isStatus, arrAllTeamMember)
    }
   //20/1
   //20/1/2020/11/2019
    //MARK:- Close window In Tempary on DAta Change in team member and event within date 16/10/2019
    func handleGetEventListWithin(_ response: Data) -> (Status: Bool, teamMember: [UserDetail], arrEventL: NSMutableArray)
    {
        var isStatus:Bool = false
        let json = JSON(data: response)
        
        //var arrTeamMember = [TeamMember]()
        var arrTeamMember = [UserDetail]()
        //var arrEvents = NSMutableArray()
        let arrAllEvents = NSMutableArray()
        let arrEvnt = NSMutableArray()
        if json["eventList"]["status"].string == "YES"
        {
            
            let eventArr = json["eventList"]["eventArr"]
            
            for i in 0..<eventArr.count
            {
                let arrEvent = eventArr[i]
                //let evetwiseArr = arrEvent["eventWiseArr"]
                //let evetwiseArr = eventArr[i]["eventWiseArr"]
                
                //print(evetwiseArr)
                //if arrEvent["userDetailArr"] != nil {
                    
                
                let userDetailArr = arrEvent["userDetailArr"]
                print(userDetailArr)
//                let teamMember : TeamMember = TeamMember()
//                teamMember.first_name = userDetailArr["first_name"].string
//                teamMember.last_name = userDetailArr["last_name"].string
//                teamMember.created_timestamp = userDetailArr["created_timestamp"].string
//                teamMember.export_allowed = userDetailArr["export_allowed"].string
//                teamMember.reportsTo = userDetailArr["reportsTo"].string
                
                // Update For 27/09/2019   close it 08/11/2019
                let teamMember : UserDetail = UserDetail()
                teamMember.userId = userDetailArr["id"].string
                teamMember.firstName = userDetailArr["first_name"].string
                teamMember.userName = ""
                teamMember.lastName = userDetailArr["last_name"].string
                teamMember.email = userDetailArr["email"].string
                teamMember.companyName = userDetailArr["companyName"].string
                teamMember.companyWebsite = userDetailArr["companyWebSite"].string
                teamMember.report = userDetailArr["reportsTo"].string
                teamMember.createTimeStamp = userDetailArr["created_timestamp"].string
                teamMember.AddedUserFor = userDetailArr["AddedUserFor"].string
                
                //EventWise DAtaa...
                let evetwiseArr = eventArr[i]["eventWiseArr"]
                    print(evetwiseArr)
                let arrEvents = NSMutableArray()
    
                for i in 0..<evetwiseArr.count
                {
                    //let dic : [String: JSON] = evetwiseArr[i].dictionary!
                    let d: [String : Any]  = evetwiseArr[i].dictionary!
                    //let dc : NSMutableDictionary = evetwiseArr[i].dictionary as! NSMutableDictionary
                    //arrEvents.add(dic.keys)
                    //arrEvents.addObjects(from: [dic.keys])
                    let componentArray = [String] (d.keys)
                    arrEvents.add(componentArray[0])
                    //arrEvents.add(d.keys)

                }
                
                for i in 0..<evetwiseArr.count
                {
                    //06/01/2020
                    var dicEvent : [String : AnyObject] = evetwiseArr[i].dictionaryObject as! [String : AnyObject]
                   
                    //var dicEvent : [String : JSON] = evetwiseArr[i].dictionaryValue
                   // print(arrEvents)
                   // print(dicEvent)
                    //let dicEvent = evetwiseArr[i].dictionaryObject
                    // 25/11/2019 Comment Line
                    //var dicEvent : [String : AnyObject] = evetwiseArr[i].dictionaryObject! as [String : AnyObject]
                    //var dicEvent = evetwiseArr[i][""].array
                    //var dicEvent : NSDictionary = evetwiseArr.arrayObject![i] as! NSDictionary
                    
                    
                    print(dicEvent)
                   for j in 0..<arrEvents.count
                    {
                       
                        //var dicEvent : [String : Any] = evetwiseArr[i].dictionaryObject!
                        //dicEvent.value(forKey: arrEvents[j] as? String ?? "")
                       // let d = dicEvent["\(arrEvents.object(at: j))"] as? [String  : AnyObject]
                        //if arrEvents[j] != nil
                        // 12/11/2019 comment line
                        //print(dicEvent["\(arrEvents.object(at: j))"]?.array)
                        
                        //dicEvent.value(forKey: arrEvents.object(at: j) as? String ?? "" ) != nil)

                        //if arrEvents.object(at: j) != nil
                        //if arrEvents[j] != nil
                       
                        if((dicEvent["\(arrEvents.object(at: j))"]) != nil)
                        {
         
                            //03/12/2019
                            let tempArr: [[String:Any]] = dicEvent["\(arrEvents.object(at: j))"] as? [[String:Any]] ?? []
                            //let tempArr = arrEvents.object(at: j) as? AnyObject
                            //let tempArr = evetwiseArr[i].array
                            
                            print(tempArr)
                            let dic = NSMutableDictionary()
                            
                            for k in 0..<tempArr.count
                            {
                                //03/12/2019
                                dicEvent = tempArr[k] as! [String : AnyObject]
                                
                                //dicEvent = tempArr[k] as! [String : JSON]
                                //29/11/2019
                                //dicEvent = tempArr.object(at: k) as! NSDictionary
                                
                                let objEvent : EventDetail = EventDetail()
                                //COMENT IN 10/12/2019
                                //objEvent.eventName = tempArr[k]["eventName"].string
                                
                                //10/12/2019 comment line
                                //06/01/2020
                                objEvent.eventName = dicEvent["eventName"] as? String
                                objEvent.eventid = (dicEvent["eventId"] as! String)
                                objEvent.createdTimeStamp = (dicEvent["eventId"] as! String)
                                objEvent.location =  dicEvent["location"] as! String
                                objEvent.city =  dicEvent["city"] as? String
                                objEvent.state =  dicEvent["state"] as? String
                                objEvent.country =  dicEvent["country"] as? String
                                objEvent.eventDate = dicEvent["eventDate"] as! String
                                objEvent.eventEndDate = dicEvent["eventEndDate"] as! String
                                objEvent.isPrivate = dicEvent["isPrivate"] as! String
                                objEvent.AddedFor = dicEvent["AddedFor"] as! String
                                objEvent.event_registration = dicEvent["event_registration"] as! String
                                objEvent.bSocial = dicEvent["b_social"] as! String
                                //arrAllEvents.add(objEvent)
                                objEvent.organizerId = dicEvent["organizerId"] as! String
                                //objEvent.eventType = dicEvent[k] as? String
                                objEvent.eventType = arrEvents[j] as? String
                                objEvent.eventTag = 100+j
                                
                                arrAllEvents.add(objEvent)
                                
                    
                            //ashish
                   // objEvent.eventName = evetwiseArr[i]["eventName"].string
                   // objEvent.createdTimeStamp = evetwiseArr[i]["eventId"].string
                    
                    
                // arrAllEvents.add(ob)
                            }
                            //10/12/2019
                          dic.setValue(arrAllEvents, forKey:arrEvents.object(at: j) as! String)
                           arrEvnt.add(dic)
                            print(arrAllEvents)
                        }
                    }
                        
                    
                    
                }
                
                arrTeamMember.append(teamMember)
            
                print(teamMember)
                
                print(evetwiseArr)
                print(userDetailArr)
      
            //userwise new if brakates..
                //}
            }
            
            print(eventArr)
            isStatus = true
        }
        
        print(arrTeamMember)
        print(arrAllEvents)
        
        return (isStatus, arrTeamMember, arrAllEvents)
        
    }
    
    //MARK: Get LeadGroup LIst...
    func handleGetLeadGroupList(_ response: Data) -> (Status: Bool, teamMember: [UserDetail], arrEvent: NSMutableArray)
    {
        var isStatus:Bool = false
        let json = JSON(data: response)
        
        var arrTeamMember = [UserDetail]()
        var arrEvents = NSMutableArray()
        let arrAllEvents = NSMutableArray()
        
        
        if json["leadGroupList"]["status"].string == "YES"
        {
            isStatus = true
            let eventArr = json["leadGroupList"]["leadGroupArr"]
            for i in 0..<eventArr.count
            {
                let eventArr = eventArr[i]
                let evetwiseArr = eventArr["LeadGroupArr"]
                let userDetailArr = eventArr["userDetailArr"]
                
                //let teamMember : TeamMember = TeamMember()
                let teamMember : UserDetail = UserDetail()
                teamMember.userId = userDetailArr["id"].string
                teamMember.firstName = userDetailArr["first_name"].string
                teamMember.lastName = userDetailArr["last_name"].string
                teamMember.email = userDetailArr["email"].string
                teamMember.createTimeStamp = userDetailArr["created_timestamp"].string
                //teamMember.export_allowed = userDetailArr["export_allowed"].string
                teamMember.report = userDetailArr["reportsTo"].string
                teamMember.companyName = userDetailArr["companyName"].string
                teamMember.companyWebsite = userDetailArr["companyWebSite"].string
                
                for i in 0..<evetwiseArr.count
                {
                    let dic : [String: Any] = evetwiseArr[i].dictionary!
                    let componentArray = [String] (dic.keys)
                    arrEvents.add(componentArray[0])
                    //arrEvents.add(dic.keys)
                }
                
                for i in 0..<evetwiseArr.count
                {
                    var dicEvent : [String : Any] = evetwiseArr[i].dictionaryObject!
                    
                    for j in 0..<arrEvents.count
                    {
                        if((dicEvent["\(arrEvents.object(at: j))"]) != nil)
                        {
                            let tempArr : [[String:Any]] = dicEvent["\(arrEvents.object(at: j))"] as? [[String:Any]] ?? []
                            let dic = NSMutableDictionary()
                            for k in 0..<tempArr.count
                            {
                                dicEvent = tempArr[k]
                                let objEvent : LeadGroupDetail = LeadGroupDetail()
                                objEvent.groupname = dicEvent["lead_group_name"] as? String
                                objEvent.createTimeStamp = (dicEvent["created_timestamp"] as! String)
                                objEvent.leadSource =  dicEvent["lead_source"] as? String ?? ""
                                objEvent.city =  dicEvent["city"] as? String ?? ""
                                objEvent.purpose = dicEvent["purpose"] as? String ?? ""
                                objEvent.contactPerson = dicEvent["contact_person"] as? String ?? ""
                                objEvent.groupDate = dicEvent["lead_group_date"] as? String ?? ""
                                objEvent.phone = dicEvent["phone"] as? String ?? ""
                                objEvent.note = dicEvent["notes"] as? String ?? ""
                                objEvent.groupType = dicEvent["isPrivate"] as? String ?? ""
                                objEvent.createDate = dicEvent["create_date"] as? String ?? ""
                                objEvent.upDate = dicEvent["update_date"] as? String ?? ""
                                objEvent.updateTimeStamp = dicEvent["updated_timestamp"] as? String ?? ""
                                //objEvent.eventType = dicEvent[k] as? String
                                objEvent.eventType = arrEvents[0] as? String ?? ""
                                objEvent.eventTag = 100+k
                                arrAllEvents.add(objEvent)
                                
                            }
                            dic.setValue(arrAllEvents, forKey:arrEvents.object(at: j) as! String)
                        }
                    }
                }
                arrTeamMember.append(teamMember)
                
                print(teamMember)
                
                print(evetwiseArr)
                print(userDetailArr)
            }
        }
        
        return (isStatus, arrTeamMember, arrAllEvents)
        
    }
    
    //MARK: RESET PASSWORD And ADD TEAM MEMBER LIST ...
    func handleGetAddTeamMember(_ response: Data) -> (Status: Bool, teamMember: [TeamMember], arrEvent: NSMutableArray)
    {
        var isStatus:Bool = false
        let json = JSON(data: response)
        
        var arrTeamMember = [TeamMember]()
        var arrEvents = NSMutableArray()
        let arrAllEvents = NSMutableArray()
        
        if json["AddTeamMember"]["status"].string == "YES"
        {
            isStatus = true
            let eventArr = json["AddTeamMember"]["AddTeamMemberList"]
            for i in 0..<eventArr.count
            {
                //let evetwiseArr = eventArr["AddTeamMemberList"]
                //let userDetailArr = eventArr["userDetailArr"]
                let userDetailArr = eventArr["AddTeamMemberList"]
                 let teamMember : TeamMember = TeamMember()
                //teamMember.userId = eventArr[i]["id"].string
                teamMember.first_name = eventArr[i]["first_name"].string
                teamMember.last_name = eventArr[i]["last_name"].string
                teamMember.reportsTo = eventArr[i]["reportsTo"].string
                teamMember.created_timestamp = eventArr[i]["created_timestamp"].string
                teamMember.export_allowed = eventArr[i]["export_allowed"].string
                
                //teamMember.first_name = userDetailArr["first_name"].string
//                teamMember.last_name = userDetailArr["last_name"].string
//                teamMember.reportsTo = userDetailArr["reportsTo"].string
//                teamMember.created_timestamp = userDetailArr["created_timestamp"].string
//                teamMember.export_allowed = userDetailArr["export_allowed"].string

                arrTeamMember.append(teamMember)
            }
        }
        return(isStatus, arrTeamMember, arrAllEvents)
    }
    
    
    //MARK: GET EVENT COUNT ...
//    -> (Status: Bool ,arrCountData: NSMutableArray)
    func handleGetEventCount(_ response: Data)
    {
           var isStatus:Bool = false
           let json = JSON(data: response)
        
          print(json)
          print("Ok")
    }
    
    
    //MARK:- Video Profile presentation Response...
    func handleGetVideoProfilePresentation(_ response: Data) -> (Status: Bool ,arrVideo: NSMutableArray)
    {//, videoList: [VideoProfileDetail]
        var isStatus:Bool = false
        //var arrVideoList = [VideoProfileDetail]()
        let arrVideoList = NSMutableArray()
        let json = JSON(data: response)
        
        if json["video_manupulation"]["status"].string == "YES"
        {
            print("Status true")
            
            let VideoList = json["video_manupulation"]["links"]
            for i in 0..<VideoList.count
            {
                let objVideoList:VideoProfileDetail = VideoProfileDetail()
                
                objVideoList.videoLink = VideoList[i]["vfile_path"].string
                objVideoList.name = VideoList[i]["name"].string
                objVideoList.description_Detail = VideoList[i]["description"].string
                objVideoList.date_Time = VideoList[i]["datetime"].string
                objVideoList.created_TimeStamp = VideoList[i]["create_timestamp"].string
                objVideoList.modify_TimeStamp = VideoList[i]["modify_timestamp"].string
                
                arrVideoList.add(objVideoList)
                
            }
            
            isStatus = true
        }
        return (isStatus,arrVideoList)
    }
    
    //MARK:- Manage Export Ability
  /*  func handleGetManageExportAbility(_ response: Data) -> Bool
    {
        var isStatus:Bool = false
        
         let json = JSON(data: response)
         let result = json["updateExportAbility"]
         if result["status"].string == "YES"
         {
             isStatus = true
         }
         return (isStatus)
    }*/

    //MARK:- Schedual Tasks Response...
    func handleGetSchedualTasksList(_ response: Data) -> (Status:Bool,TaskList:NSMutableArray)
    {
        var isStatus:Bool = false
        let arrTaskList = NSMutableArray()
        let json = JSON(data: response)
        
        if json["getTaskList"]["status"].string == "YES"
        {
            //isStatus = true
            let tasksList = json["getTaskList"]["taskList"]
            for i in 0..<tasksList.count
            {
                let userWiseTasksList = tasksList[i]["UserwiseTaskList"]
                for j in 0..<userWiseTasksList.count
                {
                    
                    let objTaskList:TaskList = TaskList()
                    
                    objTaskList.subject = userWiseTasksList[j]["subject"].string
                    objTaskList.startDate = userWiseTasksList[j]["startDt"].string
                    objTaskList.endDate = userWiseTasksList[j]["endDt"].string
                    objTaskList.priorityId = userWiseTasksList[j]["priorityId"].string
                    objTaskList.statusId = userWiseTasksList[j]["statusId"].string
                    objTaskList.created_timestamp = userWiseTasksList[j]["created_timestamp"].string
                    objTaskList.updated_timestamp = userWiseTasksList[j]["updated_timestamp"].string
                    objTaskList.leadId = userWiseTasksList[j]["userId"].string
                    objTaskList.eventId = userWiseTasksList[j]["eventId"].string
                    objTaskList.eventName = userWiseTasksList[j]["eventName"].string
                    objTaskList.isWhere = userWiseTasksList[j]["isWhere"].string
                    objTaskList.taskAddedFor = userWiseTasksList[j]["taskAddedFor"].string
                    objTaskList.teamMember = userWiseTasksList[j]["TeamMember"].string
                    
                    arrTaskList.add(objTaskList)
                }
            }
            isStatus = true
        }
        return(isStatus,arrTaskList)
    }
    func handleGetTaskList(_ response: Data) -> (Status:Bool,TaskList:NSMutableArray)
    {
        var isStatus:Bool = false
        let arrTaskList = NSMutableArray()
        let json = JSON(data: response)
        
        if json["getTaskList"]["status"].string == "YES"
        {
            //isStatus = true
            let tasksList = json["getTaskList"]["taskList"]
            for i in 0..<tasksList.count
            {
                let objTaskList:TaskList = TaskList()
                
                objTaskList.subject = tasksList[i]["subject"].string
                objTaskList.startDate = tasksList[i]["startDt"].string
                objTaskList.endDate = tasksList[i]["endDt"].string
                objTaskList.priorityId = tasksList[i]["priorityId"].string
                objTaskList.statusId = tasksList[i]["statusId"].string
                objTaskList.created_timestamp = tasksList[i]["created_timestamp"].string
                objTaskList.updated_timestamp = tasksList[i]["updated_timestamp"].string
                objTaskList.leadId = tasksList[i]["userId"].string
                objTaskList.eventId = tasksList[i]["eventId"].string
                objTaskList.eventName = tasksList[i]["eventName"].string
                objTaskList.isWhere = tasksList[i]["isWhere"].string
                objTaskList.taskAddedFor = tasksList[i]["taskAddedFor"].string
                objTaskList.teamMember = tasksList[i]["TeamMember"].string
                
                arrTaskList.add(objTaskList)
            }
            isStatus = true
        }
        return(isStatus,arrTaskList)
    }
    //MARK: Get Scheduled Tasks List Detail...
    open func handleGetTaskListDetail(_ response:Data) -> (Status:Bool,TaskListDetail:TaskList)
    {
        var isStatus:Bool = false
        let objTaskListDetail:TaskList = TaskList()
        let json = JSON(data: response)
        
        if json["getTaskDetail"]["status"].string == "YES"
        {
            let taskDetail = json["getTaskDetail"]["taskDetail"]
            
            objTaskListDetail.userId = taskDetail["userId"].string
            
            objTaskListDetail.created_timestamp = taskDetail["created_timestamp"].string
            objTaskListDetail.subject = taskDetail["subject"].string
            objTaskListDetail.startDate = taskDetail["startDt"].string
            objTaskListDetail.endDate = taskDetail["endDt"].string
            objTaskListDetail.statusId = taskDetail["statusId"].string
            objTaskListDetail.priorityId = taskDetail["priorityId"].string
            objTaskListDetail.leadId = taskDetail["leadId"].string
            objTaskListDetail.eventId = taskDetail["eventId"].string
            objTaskListDetail.eventName = taskDetail["event_name"].string
            objTaskListDetail.eventDate = taskDetail["event_date"].string
            
            objTaskListDetail.lFirstName = taskDetail["leadFirstName"].string
            objTaskListDetail.lLastName = taskDetail["leadLastName"].string
            objTaskListDetail.lCompany = taskDetail["lead_company"].string
            
            objTaskListDetail.reminderDt = taskDetail["reminderDt"].string
            objTaskListDetail.reminderTime = taskDetail["reminderTime"].string
            objTaskListDetail.reminderSet = taskDetail["reminderSet"].string
            
            objTaskListDetail.addedLeadType = taskDetail["addedLeadType"].string
            objTaskListDetail.taskIdentifire = taskDetail["taskIdentifier"].string
            objTaskListDetail.perviousTaskID = taskDetail["previousTaskId"].string
            objTaskListDetail.nextTaskId = taskDetail["nextTaskId"].string
            
            isStatus = true
        }
        return(isStatus, objTaskListDetail)
    }
    
    //MARK:- Get Scheduled Meeting Task...
    func handleGetSchedualMeetingTasksList(_ response: Data) -> (Status:Bool,MeetingList:NSMutableArray)
    {
        var isStatus:Bool = false
        let arrTaskList = NSMutableArray()
        let json = JSON(data: response)
        
        if json["getMeetingList"]["status"].string == "YES"
        {
            let meetingList = json["getMeetingList"]["meetingListArr"]
            for i in 0..<meetingList.count
            {
                let MeetingTasksList = meetingList[i]["meetingList"]
                for j in 0..<MeetingTasksList.count
                {
                    let objTaskList:MeetingList = MeetingList()
                    
                    objTaskList.subject = MeetingTasksList[j]["subject"].string
                    objTaskList.location = MeetingTasksList[j]["location"].string
                    objTaskList.meetingDate = MeetingTasksList[j]["meetingDt"].string
                    objTaskList.startTime = MeetingTasksList[j]["startTime"].string
                    objTaskList.endTime = MeetingTasksList[j]["endTime"].string
                    objTaskList.note = MeetingTasksList[j]["note"].string
                    objTaskList.createdTimeStamp = MeetingTasksList[j]["created_timestamp"].string
                    objTaskList.updateTimeStampp = MeetingTasksList[j]["updated_timestamp"].string
                    objTaskList.leadFirstName = MeetingTasksList[j]["leadFirstName"].string
                    objTaskList.leadLastName = MeetingTasksList[j]["leadLastName"].string
                    objTaskList.teamMember = MeetingTasksList[j]["TeamMember"].string
                    
                    arrTaskList.add(objTaskList)
                }
            }
            isStatus = true
        }
         return(isStatus,arrTaskList)
    }
    
    //MARK:Get Scheduled Meeting Task Detail....
    open func handleGetMeetingListDetail(_ response:Data) -> (Status:Bool,MeetingListDetail:MeetingList)
    {
        var isStatus:Bool = false
        let objMeetingListDetail:MeetingList = MeetingList()
        let json = JSON(data: response)
        
        if json["getMeetingDetail"]["status"].string == "YES"
        {
            let meetingDetail = json["getMeetingDetail"]["meetingDetail"]
            
            objMeetingListDetail.subject = meetingDetail["subject"].string
            objMeetingListDetail.location = meetingDetail["location"].string
            objMeetingListDetail.startTime = meetingDetail["startTime"].string
            objMeetingListDetail.endTime = meetingDetail["endTime"].string
            objMeetingListDetail.meetingDate = meetingDetail["meetingDt"].string
            objMeetingListDetail.note = meetingDetail["note"].string
            //objMeetingListDetail.leadId = meetingDetail["leads"].string
            objMeetingListDetail.leadId = meetingDetail["leadNames"].string
            objMeetingListDetail.createdTimeStamp = meetingDetail["created_timestamp"].string
            objMeetingListDetail.updateTimeStampp = meetingDetail["updated_timestamp"].string
            objMeetingListDetail.alertTime = meetingDetail["reminder"].string
            
            objMeetingListDetail.eventName = meetingDetail["event_name"].string
            objMeetingListDetail.eventDate = meetingDetail["event_date"].string
            
            objMeetingListDetail.leadFirstName = meetingDetail["leadFirstName"].string
            objMeetingListDetail.leadLastName = meetingDetail["leadLastName"].string
            objMeetingListDetail.leadCompany = meetingDetail["lead_company"].string
            
            objMeetingListDetail.addedLeadType = meetingDetail["addedLeadType"].string
            objMeetingListDetail.meetingIdentifier = meetingDetail["meetingIdentifier"].string
            
            objMeetingListDetail.perviousMeetingId = meetingDetail["previousMeetingId"].string
            objMeetingListDetail.nextMeetingId = meetingDetail["nextMeetingId"].string
            
            isStatus = true
            print("Success Status")
            
        }
        
        return(isStatus, objMeetingListDetail)
    }
    
    
    
    //MARK:- GET EMAIL TEMPLATE
    
    open func getEmailTemplate(_ response:Data) -> (JSON)
    {
        var tempdic:JSON = nil
        let json = JSON(data: response)
        
        if json["getEmailTemplate"]["status"] == "YES"
        {
          tempdic = json["getEmailTemplate"]["templateDetail"]
        }
        if json["getEmailTemplate"]["status"] == "NO"
        {
            let alert = UIAlertController(title: "", message: "No Such Email Template Found.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            //present(alert,animated: true,completion: nil)
        }
        return tempdic
    }
    
    //MARK:- UserWise Event Lead LIst....
    func handleGetEventLeadList(_ response: Data) -> (Status: Bool, arrEventList: NSMutableArray)
    {
        var isStatus:Bool = false
        let json = JSON(data: response)
        
        
        var arrEvents = NSMutableArray()
        let arrAllEvents = NSMutableArray()
        
        if json["getUserEventWiseLeadList"]["status"].string == "YES"
        {
            isStatus = true
            let eventArr  = json["getUserEventWiseLeadList"]["eventInfoList"].array
            if (eventArr?.count)! > 0
            {
                for i in 0...(eventArr?.count)!-1
                {
                    let data = json["getUserEventWiseLeadList"]["eventInfoList"][i]
                    //let objEvent: EventDetail = EventDetail()
                    let objEvent: EventDetail = EventDetail()
                    objEvent.eventName = data["eventName"].string
                    objEvent.location = data["location"].string
                    objEvent.city = data["city"].string
                    objEvent.eventDate = data["eventDate"].string
                    objEvent.isPrivate = data["isPrivate"].string
                    objEvent.createdTimeStamp = data["eventId"].string
                    objEvent.event_registration = data["event_registration"].string
                  /*  if data["type"] == "G"
                    {
                        objEvent.isGroup = true
                    }else{
                        objEvent.isGroup = false
                    }*/
                    arrAllEvents.add(objEvent)
                }
            }
        }
        return(isStatus, arrAllEvents)
    }
    
    //MARK:- LogOut
    open func handleLogOut(_ response:Data) -> Bool
    {
        var isStatus:Bool = false
       
        let json = JSON(data: response)
        let result = json["userLogin"]
        if result["status"].string == "YES"
        {
            
            isStatus = true
        }
        
        return (isStatus)
    }
}
