//
//  EventDetail.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 27/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class EventDetail: NSObject {
    
    var eventid:String? = nil
    var eventName:String? = nil
    var event_start_date:String? = nil
    var location:String? = nil
    var city:String? = nil
    var country:String? = nil
    var event_end_date:String? = nil
    var state:String? = nil
    var eventDescription:String? = nil
    var bSocial:String? = nil
    var eventDate:String? = nil
    var isPrivate:String? = nil
    var event_registration:String? = nil
    var eventEndDate:String? = nil
    var AddedFor:String? = nil
    var Agenda:String? = nil
    var organizerId:String? = nil
    var eventType:String? = nil
    var eventTag:Int? = nil
    
    var eventlogo:String? = nil
    var previouseEventId:String? = nil
    var nextEventId:String? = nil
    var updatedTimeStamp:String? = nil
    var Isownevent:String? = nil
    var phone_ext:String? = nil
    var event_can_delete:String? = nil
    var linkedInUrl:String? = nil
    var facebookUrl:String? = nil
 
    var createdTimeStamp:String? = nil
    var numberOfLeads:String? = nil
    var contactPerson:String? = nil
    var event_has_attendee:String? = nil
    var other_phone:String? = nil
    
    var twitterUrl:String? = nil
    var purpose:String? = nil
    var notes:String? = nil
    var phone:String? = nil
    var organizer_name:String? = nil
    var showattendees:String? = nil
    var timezone:String? = nil
    
    var isGroup:Bool? = false
    
    var surveyLink = NSArray()
    
    
}

class surveyLink: EventDetail {
    
    var name:String? = nil
    var link:String? = nil
    
}
