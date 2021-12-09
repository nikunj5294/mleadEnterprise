//
//  EventsDetailViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 27/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EventsDetailViewController: UIViewController,NVActivityIndicatorViewable {

    var objEventDetail: EventDetail = EventDetail()
    
    @IBOutlet var lblEventsName: UILabel!
    @IBOutlet var lblEventsLocation: UILabel!
    @IBOutlet var lblEventsCity: UILabel!
    @IBOutlet var lblEventsState: UILabel!
    @IBOutlet var lblEventsDate: UILabel!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "View Event"
        let edit = UIBarButtonItem(image:UIImage(named: "edit_lead"), style: .plain, target: self, action: #selector(self.btnEditClick(_:)))//#selector(addTapped)
        let delete = UIBarButtonItem(image:UIImage(named: "delete_lead"), style: .plain, target: self, action: #selector(btnDeleteClick(_:)))//)btnExportAction
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = -26.0
        
        self.navigationItem.rightBarButtonItems = [delete,fixedSpace,edit]
        
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
        VC.selectedEventObj = self.objEventDetail
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteLeadViewController") as! DeleteLeadViewController
        vc.selectedEventObj = self.objEventDetail
        self.navigationController?.pushViewController(vc, animated: true)
        /*
        */
    }

    func handleShareLeadsClick() {
    }

    func handleunShareleadsClick() {
        
        //leads follow up clicked
    }

    func HandleTransferLeadsClick() {
        
        
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        vc.isEditEvent = true
        vc.objEventDetail = self.objEventDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        // create the alert
        let alert = UIAlertController(title: "Mleads", message: "Are you sure, you want to delete this event?", preferredStyle: UIAlertController.Style.alert)

               // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (Alert) in
            print("Delete")
            
            let dict = [
                "eventId" : self.objEventDetail.eventid
                ] as [String : AnyObject]
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            self.webService.doRequestPost(DELETE_EVENT_BY_ID_API_URL, params: dict, key: "deleteEvent", delegate: self)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Webservices Method...
extension EventsDetailViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == DELETE_EVENT_BY_ID_API_URL
        {
            
            let json = JSON(data: response)
            print(json)

            if json["getDeleteEvent"]["status"].string == "YES"
            {
                self.navigationController?.popViewController(animated: true)
                print("TRUE")
            }else{
                print("FALSE")
            }
            
        }
        else if apiKey == DELETE_LEAD_API_URL
        {
            
            let json = JSON(data: response)
            print(json)

            if json["getDeleteLead"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "All Leads deleted successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Delete Leads!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                print("TRUE")
            }else{
                print("FALSE")
            }
            
        }
        
       
    }
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}
