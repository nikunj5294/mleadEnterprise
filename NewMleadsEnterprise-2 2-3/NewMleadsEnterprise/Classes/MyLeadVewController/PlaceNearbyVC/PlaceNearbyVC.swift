//
//  PlaceNearbyVC.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 14/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PlaceNearbyVC: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var tblView: UITableView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.register(UINib(nibName: "LeadEventTblCell", bundle: nil), forCellReuseIdentifier: "LeadEventTblCell")
        callAPIToGetPlaceNearby()
    }
    

    func callAPIToGetPlaceNearby()
    {
        
//        let param:[String : AnyObject] = ["location":"Ahmedabad" as AnyObject, "category":"business" as AnyObject, "app_key" : "QfFnL4ttT5jwb7zh" as AnyObject, "page_size" : 10 as AnyObject, "page_number" : 1 as AnyObject]
//            self.objLeadList.createTimeStamp
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        let url : String = "http://api.eventful.com/json/events/search?location=Ahmedabad&category=business&app_key=QfFnL4ttT5jwb7zh&page_size=10&page_number=1"
//        var request : NSMutableURLRequest = NSMutableURLRequest()
//        request.url = URL(string: url)
//        request.httpMethod = "GET"
        URLSession.shared.dataTask( with: URL(string: url)!) {data, response, error in
            if((error) != nil) {
            print(error!.localizedDescription)
            
        }else {
//                _ = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
//                let _: NSError?
            
//            let URL:String = ((response?.url)?.lastPathComponent)!
            let json = JSON(data: data!)
            print("Response string:\(json)")
            
        }
    }.resume()
        
//        self.webService.doRequestPost(TRANFER_LEADS, params: param, key: "search", delegate: self)
    }

}
extension PlaceNearbyVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadEventTblCell", for: indexPath) as! LeadEventTblCell
        cell.selectionStyle = .none
        
                
//        let teamMember = arrTeamMemberList[indexPath.row]
//        cell.lblUserName.text = teamMember.first_name! + " " + teamMember.last_name!
//        cell.lblCompanyName.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
