//
//  ReportViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 14/10/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    var menuSegues = NSMutableArray()
    var images = Array<UIImage>()
    var alertbtnColor = Utilities.alertButtonColor()
    
    var yearArray = NSMutableArray()
    var selectedIndex = Int()
    var arrYear = [String]()
    //let objSheet = UIActionSheetAlertView
    @IBOutlet var tblView: UITableView!
    @IBOutlet var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Reports"
        self.findHamburguerViewController()?.gestureEnabled = false
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        menuSegues = ["Scheduled Tasks", "Scheduled Metting","Email Statistics","Sales Report","Sales Cycle Report","Pipeline Sales Report","PipeLine Report","Converted Lead To Customer","# and % of Lead by Lead Qualifier","Product Interest by Percentage"]
        images = [#imageLiteral(resourceName: "shedule158"),#imageLiteral(resourceName: "Scheduled Mettinng158"),#imageLiteral(resourceName: "Mail Stastic.158"),#imageLiteral(resourceName: "Sales Report158"),#imageLiteral(resourceName: "SalescCycle Report158"),#imageLiteral(resourceName: "Pipeline Sales.158"),#imageLiteral(resourceName: "pipeline-Report.158"),#imageLiteral(resourceName: "Converted Lead To Customer158"),#imageLiteral(resourceName: "LeadByLead Qualifier 0158"),#imageLiteral(resourceName: "Product-inverted158")]
        tblView.reloadData()
    }
    
    //MARK:- PipeLine Report...
    func pipeLineReport(){
       let startYear = 2012
        print("PipLine Button Click")
        StringPickerPopOver.appearFrom(originView: view!, baseView: menuSegues[6] as! UIView, baseViewController: self, title: "Select Year", choices: arrYear  , initialRow: selectedIndex, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
	
        },cancelAction: { print("cancel")})

        if yearArray.count > 0 && yearArray != nil {
            //yearArray = nil
        }
        //let startYear = 2012
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let stringCurrentYear = formatter.string(from: currentDate)
        let endYear = Int(stringCurrentYear) ?? 0 + 2
        yearArray.removeAllObjects()
        
        for i in startYear...endYear {
            yearArray.addObjects(from: [i])
        }
        selectedIndex = 0
        
        

    }
}
//MARK:- UITable View Delegate / DataSource Method...
extension ReportViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSegues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReport", for: indexPath)
        
        let imgIcon : UIImageView = cell.contentView.viewWithTag(201) as! UIImageView
        let lblTitle : UILabel = cell.contentView.viewWithTag(202) as! UILabel
        
        imgIcon.image = images[indexPath.row]
        lblTitle.text = menuSegues[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath\(indexPath.row)")
        if indexPath.row == 0{
            print(" ")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ScheduledTasksViewController") as! ScheduledTasksViewController
            //let VC = mainStoryboard.instantiateViewController(withIdentifier:  "test2ViewController") as! test2ViewController
            VC.isfromreport = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 1{
            print("")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ScheduledMeetingViewController") as! ScheduledMeetingViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 2{
            print("")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "EmailStatisticsViewController") as! EmailStatisticsViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 3 {
            print("")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "SalesReportViewController") as! SalesReportViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 4 {
            print("")
                        let VC = mainStoryboard.instantiateViewController(withIdentifier:  "SalesCycleReportViewController") as! SalesCycleReportViewController
                        self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 5 {
            print("")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "PipelineSalesReportViewController") as! PipelineSalesReportViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 6 {
            print("")
            //pipeLineReport()
            let VC = mainStoryboard.instantiateViewController(withIdentifier: "PipeLineViewController") as! PipeLineViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 7 {
            print("")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ConvertedLeadToCustomerViewController") as! ConvertedLeadToCustomerViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 8 {
            print("")
                        let VC = mainStoryboard.instantiateViewController(withIdentifier:  "LeadbyLeadQulalifierViewController") as! LeadbyLeadQulalifierViewController
                        self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 9 {
            print("")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ProductIntrestbyPercentageViewController") as! ProductIntrestbyPercentageViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}



