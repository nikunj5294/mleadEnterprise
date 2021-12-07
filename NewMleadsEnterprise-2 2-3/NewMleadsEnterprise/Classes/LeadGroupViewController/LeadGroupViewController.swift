//
//  LeadGroupViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 22/08/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView

class LeadGroupViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable,WebServiceDelegate {
 
    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    @IBOutlet var btnGroupWithin: UIButton!
    @IBOutlet var lblGroupWithin: UILabel!
    
    @IBOutlet var LeadGroupPopupView: UIView!
    
    @IBOutlet var tableView: UITableView!
    var selectedIndexForEventsWithin = Int()
    var selectedIndexForTeamMember = Int()
    var typeID = String()
    var selectedID = String()
    var reportID = String()
    var selectedRow = Int()
    
    var arrGroupList = NSMutableArray()
    var arrTempReportsTo = NSMutableArray()
    let arrTempCreatedTimestamp = NSMutableArray()
    var arrEventList = NSMutableArray()
    
    var arrOfDictionary = [[String : String]]()
    var arrTeamName = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //
        self.navigationItem.title = "Lead Group"
        self.findHamburguerViewController()?.gestureEnabled = false
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.btnFilterAction(_:)))
        self.LeadGroupPopupView.isHidden = true
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        self.callWebService(TypeId: "17", selectedId: objLoginUserDetail.userId!)
        
        tableView.reloadData()
    }
    
    //MARK: Webservices Custom Function Call Method...
    func callWebService(TypeId:String,selectedId:String)
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "selectedId":selectedId as AnyObject,
                                          "typeId":TypeId as AnyObject]
        print("param : \(param)")
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        webService.doRequestPost(GET_ALL_GROUPLIST_URL, params: param, key: "leadGroupList", delegate: self)
    }
    
    //MARK:- Button Add LeadGroup Action...
    @IBAction func btnAddLeadGroupAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    //MARK:- BackArrow Button Action...
    @IBAction func btnBackClickAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let back = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        let navigationVc = UINavigationController(rootViewController: back)
        present(navigationVc, animated: true, completion: nil)
    }
    //MARK:- Button Filter Action...
    @IBAction func btnFilterAction(_ sender: Any) {
        LeadGroupPopupView.isHidden = false
        
        for i in 0..<arrTeamCreatedTiemStemp.count
        {
            if arrTeamCreatedTiemStemp[i] == objLoginUserDetail.userId
            {
                lblTeamMember.text = arrTeamName[i]
            }
        }
    }
    
    //MARK:- Button TeamMember And Group Within Action...
    @IBAction func btnTeamMemberDropdown(_ sender: Any) {
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamName , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            self.selectedID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.reportID = self.arrTempReportsTo[self.selectedIndexForTeamMember] as! String
            print("reportID\(self.reportID)")
            
            self.selectedRow = selectedRow
            var reportsTo = String()
            
            for i in 0..<self.arrOfDictionary.count
            {
                let name = self.arrOfDictionary[i] as NSDictionary
                if (name.value(forKey: objLoginUserDetail.createTimeStamp!) != nil){
                    reportsTo = name.value(forKey: objLoginUserDetail.createTimeStamp!) as! String
                }
            }
            print("Report To of Login User is : \(reportsTo)")
            self.lblTeamMember.text = selectedString
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select id = \(self.selectedID)")
            self.callWebService(TypeId: self.typeID, selectedId: self.selectedID.count > 0 ? self.selectedID : objLoginUserDetail.userId!)
        }, cancelAction:{print("cancel")})
        self.tableView.reloadData()
    }
    
    @IBAction func btnGroupWithinDropDown(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnGroupWithin, baseViewController: self, title: "Select Duration", choices: arrWithinEvents.duration , initialRow:selectedIndexForEventsWithin, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForEventsWithin = selectedRow
            self.typeID = arrWithinEvents.typeID[self.selectedIndexForEventsWithin]
            self.lblGroupWithin.text = selectedString
            print("For Evenyt Within = \(self.selectedIndexForEventsWithin)")
            print("typeid = \(self.typeID)")
            
            self.callWebService(TypeId: self.typeID, selectedId: self.selectedID.count > 0 ? self.selectedID : objLoginUserDetail.userId!)
            
        } ,cancelAction: { print("cancel")})
    }
    
    //MARK:- OUTSide Touch Animation...
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.LeadGroupPopupView.isHidden = true
    }
    
    //MARK:-WEbservices Call Method...
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        LeadGroupPopupView.isHidden = true
        if apiKey == GET_ALL_GROUPLIST_URL
        {
            let result = handleWebService.handleGetLeadGroupList(response)
            print(result.Status)
            print(result.teamMember)
            
            let arrTempN = NSMutableArray()
            let arrTempExportAllowed = NSMutableArray()
            
            arrTeamName.removeAll()
            arrTeamCreatedTiemStemp.removeAll()
            arrTempReportsTo.removeAllObjects()
            
            for i in 0..<result.teamMember.count{
                
                //arrTeamName.append(result.teamMember[i].first_name! + " " + result.teamMember[i].last_name!)
                
                arrTeamName.append(result.teamMember[i].firstName! + " " + result.teamMember[i].lastName!)
                
                arrTeamCreatedTiemStemp.append(result.teamMember[i].createTimeStamp!)
                arrTempReportsTo.add(result.teamMember[i].report!)
                //arrTempExportAllowed.add(result.teamMember[i].export_allowed)
            }
            print("selectid \(selectedID) and typeid \(typeID)")
            arrGroupList = result.arrEvent
            tableView.reloadData()
            //isFirstTimeCall = true
        }
        tableView.reloadData()
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        LeadGroupPopupView.isHidden = true
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
    
}

//MARK: TableView DataSource MEthod DElegate MEthod...
extension LeadGroupViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objevent:Event
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        let lblGroupName:UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLeadSource:UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let lbldate:UILabel = cell.contentView.viewWithTag(103) as! UILabel
        
        let value : LeadGroupDetail = arrGroupList[indexPath.row] as! LeadGroupDetail
        print(value.groupname)
        print(value.leadSource)
        //objevent = arrGroupList[indexPath.row] as LeadGroupDetail

        lblGroupName.text = value.groupname!
        lblLeadSource.text = value.leadSource!
        
        //print(self.arrEventList[indexPath.row]["groupname"] as? String ?? "")
        //lblGroupName.text = arrEventList[indexPath.row] as? String ?? ""
        
       
        let strDate = Utilities.dateFormatter(Date: value.groupDate!, FromString: "yyyy-MM-dd", ToString: "MM/dd/yyyy")
        lbldate.text = strDate
        
        return cell
    }
}

extension LeadGroupViewController: dismissAddMenuPopUpDelegate{
    func pressAddButtonClicked(index: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            switch index {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLeadViewController")as! AddLeadViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLeadGroupViewController") as! AddLeadGroupViewController
                 self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                print("3")
            case 4:
                print("4")
            default:
                print("dismiss")
            }
        }
        
    }
    
    
}

