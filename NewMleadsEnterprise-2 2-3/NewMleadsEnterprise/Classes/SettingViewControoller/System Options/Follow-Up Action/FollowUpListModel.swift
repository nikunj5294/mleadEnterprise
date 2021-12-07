//
//  FollowUpListModel.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 20/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation

class FollowUpList{
    
    var action = ""
    var actionId = ""
    var userId = ""
    
    public class func FollowupData(dic:[[String:Any]]) -> [FollowUpList]{
        var dataFollow = [FollowUpList]()
        
        for i in dic{
            let value = SingleFollowData(SingleData: i)
            dataFollow.append(value)
        }
        return dataFollow
    }
    
    public class func SingleFollowData(SingleData:[String:Any]) -> FollowUpList{
        let FollowData = FollowUpList()
        
        FollowData.action = String(format: "%@", SingleData["action"] as! CVarArg)
        FollowData.actionId = String(format: "%@", SingleData["actionId"] as! CVarArg)
        FollowData.userId = String(format: "%@", SingleData["userId"] as! CVarArg)
        
        return FollowData
    }
}
