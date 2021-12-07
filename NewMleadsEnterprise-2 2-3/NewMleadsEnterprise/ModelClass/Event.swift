//
//  Event.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 27/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class Event: NSObject,NSCoding {
    
    var eventName:String? = nil//
    var eventId:String? = nil//
    var eventStartDate:String? = nil
    var event_end_date:String? = nil
    
    var location:String? = nil//
    var city:String? = nil//
    var country:String? = nil//
   
    var state:String? = nil//
    var registrationEndDate:String? = nil
    var image:String? = nil
    var eventDescription:String? = nil
    
    var bSocial:String? = nil//
    var eventDate:String? = nil//
    var organizerId:String? = nil//
    var isPrivate:String? = nil
    var event_registration:String? = nil//
    var eventEndDate:String? = nil//
    //var shared:String? = nil
    var AddedFor:String? = nil      //eventAddedFor
    var Agenda:String? = nil        //isAgenda
    var isGroup:String? = nil       //isGroup
    
    
    
    
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.eventName = aDecoder.decodeObject(forKey: "eventName") as? String
        self.eventId = aDecoder.decodeObject(forKey: "eventId") as? String
        self.eventStartDate = aDecoder.decodeObject(forKey: "event_start_date") as? String
       
        self.location = aDecoder.decodeObject(forKey: "location") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.country = aDecoder.decodeObject(forKey: "country") as? String
        
        self.event_end_date = aDecoder.decodeObject(forKey: "event_end_date") as? String
        self.state = aDecoder.decodeObject(forKey: "state") as? String
        self.registrationEndDate = aDecoder.decodeObject(forKey: "registration_end_date") as? String
        self.image = aDecoder.decodeObject(forKey: "event_image") as? String
        self.eventDescription = aDecoder.decodeObject(forKey: "event_description") as? String
        self.bSocial = aDecoder.decodeObject(forKey: "b_social") as? String
        self.eventDate = aDecoder.decodeObject(forKey: "eventDate") as? String
        
        self.organizerId = aDecoder.decodeObject(forKey: "organizerId") as? String
        self.isPrivate = aDecoder.decodeObject(forKey: "isPrivate") as? String
        self.event_registration = aDecoder.decodeObject(forKey: "event_registration") as? String
        self.eventEndDate = aDecoder.decodeObject(forKey: "eventEndDate") as? String
       
        self.AddedFor = aDecoder.decodeObject(forKey: "AddedFor") as? String
        self.Agenda = aDecoder.decodeObject(forKey: "Agenda") as? String
    }
    
    open func encode(with aCoder: NSCoder){
        aCoder.encode(eventName, forKey: "eventName")
        aCoder.encode(eventId, forKey: "eventId")
        aCoder.encode(eventStartDate, forKey: "event_start_date")
       
        aCoder.encode(location, forKey: "location")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(country, forKey: "country")
        
        aCoder.encode(event_end_date, forKey: "event_end_date")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(registrationEndDate, forKey: "registration_end_date")
        aCoder.encode(image, forKey: "event_image")
        aCoder.encode(eventDescription, forKey: "event_description")
        aCoder.encode(bSocial, forKey: "b_social")
        aCoder.encode(eventDate, forKey: "eventDate")
        
        aCoder.encode(organizerId, forKey: "organizerId")
        aCoder.encode(isPrivate, forKey: "isPrivate")
        aCoder.encode(event_registration, forKey: "event_registration")
        aCoder.encode(eventEndDate, forKey: "eventEndDate")
        
        aCoder.encode(AddedFor, forKey: "AddedFor")
        aCoder.encode(Agenda, forKey: "Agenda")
        
    }
}
