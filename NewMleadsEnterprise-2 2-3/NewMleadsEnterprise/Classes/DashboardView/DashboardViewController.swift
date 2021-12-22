//
//  DashboardViewController.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 09/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class DashboardViewController: UIViewController, WebServiceDelegate, NVActivityIndicatorViewable {
    
    var menuSegues = NSMutableArray()
    
    @IBOutlet var DashboardCollection: UICollectionView!
    
    @IBOutlet weak var btnMenuDrawer: UIBarButtonItem!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var imageView:UIImageView? = nil
    var isFirstTimeOpen = Bool()
    let dashboadNameArr = ["DashBoard","My Lead","Events","Lead-Group","Email Templets","Reports"]
    //let dashboadNameArr = ["Dashboad","Events","Lead-group","Mail","my Lead","Result"]
    //let dashboadImage:[UIImage] = [UIImage(named: "dashboad")!,UIImage(named: "event")!,UIImage(named: "lead-group")!,UIImage(named: "mail")!,UIImage(named: "my-lead")!,UIImage(named: "result")!]
    let dashboadImage:[UIImage] = [UIImage(named: "dashboad")!,UIImage(named: "Mleads_logo")!,UIImage(named: "event")!,UIImage(named: "lead-group")!,UIImage(named: "mail")!,UIImage(named: "result")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        
        isFirstTimeOpen = true
        self.findHamburguerViewController()?.gestureEnabled = false
         //self.navigationController?.isNavigationBarHidden = true
        
        //Temparary button...
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "Converted Lead To Customer158"), style: .plain, target: self, action: #selector(btnReferTapped))
        
        //MARK: CollectionView All Cell Design Width And Height..
        DashboardCollection.dataSource = self
        DashboardCollection.delegate = self
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.openSubscribeDialog), name: Notification.Name("OpenSubscriptionDialog"), object: nil)

        
        var layout = self.DashboardCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20,left: 20,bottom: 0,right: 20)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.DashboardCollection.frame.size.width - 20)/2, height: self.DashboardCollection.frame.size.height/3)
        
        
        if USERDEFAULTS.bool(forKey: IS_ALREADY_LOGIN){
            let barBackBtn = Utilities.NevigationBackBtn(view:self,target: self, action: #selector(self.btnMenuDrawer(_:)),Image: UIImage(named: "bargurMenu")!)
            self.navigationItem.leftBarButtonItem = barBackBtn
            self.navigationItem.title = "Dashboard"
        }else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "account"), style: .plain, target: self, action: #selector(self.btnMenuDrawer(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        }
        // Do any additional setup after loading the view.
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.findHamburguerViewController()?.gestureEnabled = true
        //
    }
    
    @IBAction func btnMenuDrawer(_ sender: Any) {
        //self.findHamburguerViewController()?.showMenuViewController()
        if USERDEFAULTS.bool(forKey: IS_ALREADY_LOGIN)
        {
            self.findHamburguerViewController()?.showMenuViewController()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK:- ADD Button ACtion...
    @IBAction func btnAddActionClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        //self.navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnUpgradeClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpgradeViewController") as! UpgradeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnViewDemoClicked(_ sender: Any) {
        
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
//        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(SUBMIT_REQUEST_FOR_DEMO_API, params: param, key: "addrequest", delegate: self)
        
        let alert = UIAlertController(title: "", message: "Demo request sent successfully.",  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
        
    }
    
    
    
    //MARK:- ViewTransParent PopUp...
    func showAnimate()
    {
        self.modalPresentationStyle = .overCurrentContext
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @objc func openSubscribeDialog()  {
        let VC = self.storyboard?.instantiateViewController(identifier: "SubscriptionPopUpViewController")
        VC!.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(VC!, animated: false, completion: nil)
    }
    
    //MARK:- Refer To Friend
    @objc func btnReferTapped()  {
        //let arrLinkk = NSArray()
        let linkRefer = "I want to refer MLeads. Download Link: https://www.myleadssite.com/refer_middle_page.php?refer_key= \(objLoginUserDetail.userId!) You will get 10% discount off the subscription price."
        
        let activityConroller = UIActivityViewController(activityItems: [linkRefer], applicationActivities: nil)
        print(activityConroller)
        present(activityConroller, animated: true) {
            print("presented")
        }
    }
   
 
    
    // MARK: - Navigation
    func mainNavigationController() -> DLHamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "HomeNevigation") as! DLHamburguerNavigationController
    }
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
           stopAnimating()
           
           if apiKey == SUBMIT_REQUEST_FOR_DEMO_API
           {
               let result = handleWebService.handleGetAddTeamMember(response)
               
               if result.Status
               {
                   
               }
               
           }
           //        print("selectid \(selectedID) and typeid \(typeID)")
           //isFirstTimeCall = true
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
    
    
    
    //MARK: Device
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//
//        // 2. check the idiom
//        switch (deviceIdiom) {
//
//        case .pad:
//            return 150
//        case .phone:
//            return 120
//        default:
//            return 172
//        }
//    }
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to ` a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- UICollectionView Delegate MEthod
extension DashboardViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboadNameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCollectionViewCell
        cell.lblDashboardName.text = dashboadNameArr[indexPath.row]
        cell.imgDashboard.image = dashboadImage[indexPath.row]
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.contentView.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = DashboardCollection.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        
        print("indexPath\(indexPath.row)")
        if indexPath.row == 0{
            let myLeadtVC = mainStoryboard.instantiateViewController(withIdentifier:  "DashboardReportViewController") as! DashboardReportViewController
            self.navigationController?.pushViewController(myLeadtVC, animated: true)
        }
        else if indexPath.row == 1{
            let myLeadtVC = mainStoryboard.instantiateViewController(withIdentifier:  "MyLeadViewController") as! MyLeadViewController
            self.navigationController?.pushViewController(myLeadtVC, animated: true)
            
        }
        else if indexPath.row == 2{
            let eventVC = mainStoryboard.instantiateViewController(withIdentifier:  "EventViewController") as! EventViewController
            //let eventVC = mainStoryboard.instantiateViewController(withIdentifier:  "TestViewController") as! TestViewController
            self.navigationController?.pushViewController(eventVC, animated: true)
            
        }
        else if indexPath.row == 3{
            let eventVC = mainStoryboard.instantiateViewController(withIdentifier:  "LeadGroupViewController") as! LeadGroupViewController
            self.navigationController?.pushViewController(eventVC, animated: true)
        }
        else if indexPath.row == 4{
            print("data Not printe Error On Page MAil ")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailTemplateListVC") as! EmailTemplateListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 5{
            print("data Not printe Error On Page Report")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ReportViewController") as! ReportViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else{
            print("Select Any Cell")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = DashboardCollection.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.4, height: height * 0.2)
        
    }
    
}


extension DashboardViewController: dismissAddMenuPopUpDelegate{
    func pressAddButtonClicked(index: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            switch index {
            case 0:
                print("0")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyLeadViewController") as! MyLeadViewController
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailTemplateListVC") as! EmailTemplateListVC
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("dismiss")
            }
        }
        
    }
    
    
}

////MARK:- WEbservices REsponse MEthod...
//extension DashboardViewController: WebServiceDelegate{
//
//
//}

