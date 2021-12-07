//
//  EventsDetailViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 27/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class EventsDetailViewController: UIViewController {

    var objEventDetail: EventDetail = EventDetail() 
    
    @IBOutlet var lblEventsName: UILabel!
    @IBOutlet var lblEventsLocation: UILabel!
    @IBOutlet var lblEventsCity: UILabel!
    @IBOutlet var lblEventsState: UILabel!
    @IBOutlet var lblEventsDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "View Event"
        setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupData() {
        lblEventsName.text = objEventDetail.eventName
        lblEventsCity.text = objEventDetail.city
        lblEventsState.text = objEventDetail.state
        lblEventsLocation.text = objEventDetail.location
        
        
//        if objEventDetail.date != nil{
//
//        }
        
        if objEventDetail.eventDate != nil{
            
        }
        
        if objEventDetail.eventDate != nil{
            lblEventsDate.text = Utilities.dateFormatter(Date: objEventDetail.eventDate!, FromString: "yyyy-MM-dd", ToString: "MM-dd-yyyy")
        }
    }
    
    @IBAction func eventActionsClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("1")
            self.handelTaskClick()
        case 2:
            print("2")
            self.handelLeadsClick()
        case 3:
            print("3")
            self.handelImportCLick()
        case 4:
            print("4")
            self.handlePlacesClick()
        case 5:
            print("5")
            self.handleMessageClick()
        case 6:
            print("6")
            self.handleDeleteAllClick()
        case 7:
            print("7")
            self.handleShareLeadsClick()
        case 8:
            print("8")
            self.handleunShareleadsClick()
        case 9:
            print("9")
            self.HandleTransferLeadsClick()
        default:
            print("ok")
            self.HandleTransferLeadsClick()
        }
    }
    


    func handelTaskClick() {
        let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ScheduledTasksViewController") as! ScheduledTasksViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }

    func handelLeadsClick() {
        let myLeadtVC = mainStoryboard.instantiateViewController(withIdentifier:  "MyLeadViewController") as! MyLeadViewController
        myLeadtVC.selectedEventObj = self.objEventDetail
        self.navigationController?.pushViewController(myLeadtVC, animated: true)
    }

    func handelImportCLick() {
    }

    func handlePlacesClick() {
        let eventVC = mainStoryboard.instantiateViewController(withIdentifier:  "TestViewController") as! TestViewController
        self.navigationController?.pushViewController(eventVC, animated: true)
    }

    func handleMessageClick() {
    }

    func handleDeleteAllClick() {
    }

    func handleShareLeadsClick() {
    }

    func handleunShareleadsClick() {
        
        //leads follow up clicked
    }

    func HandleTransferLeadsClick() {
        
        
    }
    
    

}
