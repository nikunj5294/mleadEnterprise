//
//  VideoProfileDetail.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 23/01/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
class VideoProfileDetail: NSObject, NSCoding{
    
    var videoLink: String? = nil
    var name: String? = nil
    var description_Detail: String? = nil
    var date_Time: String? = nil
    var created_TimeStamp: String? = nil
    var modify_TimeStamp: String? = nil
    var status : String? = nil
    
    public required convenience init?(coder MDecoder: NSCoder) {
        self.init()
        
        self.videoLink = MDecoder.decodeObject(forKey: "videoLink") as? String
        self.name = MDecoder.decodeObject(forKey: "Name") as? String
        self.description_Detail = MDecoder.decodeObject(forKey: "description") as? String
        self.date_Time = MDecoder.decodeObject(forKey: "date") as? String
        self.created_TimeStamp = MDecoder.decodeObject(forKey: "createdTimeStamp") as? String
        self.modify_TimeStamp = MDecoder.decodeObject(forKey: "modify_timestamp") as? String
        self.status = MDecoder.decodeObject(forKey: "status") as? String
       
    }
    
    open func encode(with MCoder: NSCoder){
        MCoder.encode(videoLink, forKey: "video_Link")
        MCoder.encode(name, forKey: "name")
        MCoder.encode(description_Detail, forKey: "description")
        MCoder.encode(date_Time, forKey: "date")
        MCoder.encode(created_TimeStamp, forKey: "createdTimeStamp")
        MCoder.encode(modify_TimeStamp, forKey: "modify_timestamp")
        MCoder.encode(status, forKey: "status")
    }
}
