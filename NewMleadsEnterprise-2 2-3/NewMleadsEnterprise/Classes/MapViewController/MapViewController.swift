//
//  MapViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 02/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import GoogleMaps
import NVActivityIndicatorView

class MapViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var lblDistanceObj: UILabel!
    
    @IBOutlet weak var mapViewObj: GMSMapView!
    private let locationManager = CLLocationManager()

    private var infoWindow = MapMarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()

    var arrDistance = ["50","100"]
    var selectedIndex = 0
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapViewObj.isMyLocationEnabled = true
        
        self.lblDistanceObj.text = arrDistance[selectedIndex] + " Miles"

        self.title = "Leads near me"
        
        CallDistanceAPI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDistancePickerClicked(_ sender: UIButton) {
        
        StringPickerPopOver.appearFrom(originView: sender as UIView, baseView: sender, baseViewController: self, title: "Select Distance", choices: arrDistance , initialRow:selectedIndex, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndex = selectedRow
            self.lblDistanceObj.text = selectedString + " Miles"
            self.CallDistanceAPI()

        }, cancelAction:{print("cancel")})
        
    }
    
    func CallDistanceAPI() {
        
        let dictAPI = ["eventId" : "100",
        "typeId" : arrDistance[selectedIndex],
        "userId" : objLoginUserDetail.createTimeStamp!,
        "lat" : locationManager.location?.coordinate.latitude ?? 0.0,
        "lng" : locationManager.location?.coordinate.longitude ?? 0.0] as [String:AnyObject]
   
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_LEAD_BYMAP_KEY, params: dictAPI, key: "getLeadList", delegate: self)
        
    }
    
    func loadNiB() -> MapMarkerWindow {
        let infoWindow = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
        return infoWindow
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapViewObj.isMyLocationEnabled = true
        mapViewObj.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapViewObj.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
    
}


//MARK:- Webservices Method...
extension MapViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_LEAD_BYMAP_KEY
        {
            let json = JSON(data: response)
            print(json)
            if json["getLeadList"]["status"].string == "YES"
            {
                
                if json["getLeadList"]["getLeadListArr"] != nil{
                    
                    let arrdata = json["getLeadList"]["getLeadListArr"]
                    if arrdata.count > 0{
                        for i in 0..<arrdata.count
                        {
                            let dict = arrdata[i]
                            let lat = Double(dict["lat"].string ?? "")
                            let long = Double(dict["lng"].string ?? "")
                            
                            let location = CLLocationCoordinate2D(latitude:lat!, longitude:long!)
//                            print("location1: \(location)")
                            let marker = GMSMarker()
                            marker.position = location
                            let name =  dict["firstName"].string ?? "" + " \(dict["lastName"].string ?? "")"
                            marker.icon?.accessibilityIdentifier = "\(i)"
                            marker.snippet = name
                            marker.userData = dict.dictionary
//                            marker.title =
                            marker.map = mapViewObj
                            marker.icon = GMSMarker.markerImage(with:.red)
//                            marker.icon = UIImage(named: "Location_Icon")
                            
                        }
                        
                    }

                    
                    
                }
//
//
//                ShowAlert(title: "Mleads", message: "Task created successfully", buttonTitle: "OK") {
//                    for case let vc as CreateTaskListing in self.navigationController?.viewControllers ?? [UIViewController()] {
//                        NotificationCenter.default.post(name: Notification.Name("callRefreshTaskListAPI"), object: nil, userInfo: nil)
//                        self.navigationController?.popToViewController(vc, animated: true)
//                    }
//                }
                
            }else{
                ShowAlert(title: "Mleads", message: "Something went wrong please try again", buttonTitle: "Ok") {
                }
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

extension MapViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var markerData : NSDictionary?
        if let data = marker.userData! as? NSDictionary {
            markerData = data
        }
        locationMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
        // Pass the spot data to the info window, and set its delegate to self
        infoWindow.spotData = markerData
        infoWindow.delegate = self
        // Configure UI properties of info window
        infoWindow.alpha = 0.9
        infoWindow.layer.cornerRadius = 12
        infoWindow.layer.borderWidth = 2
        infoWindow.layer.borderColor = UIColor(named: "app_theme_color")?.cgColor
//        infoWindow.infoButton.layer.cornerRadius = infoWindow.infoButton.frame.height / 2
            
        
        let firstName = markerData!["firstName"]!
        let lastName = markerData!["lastName"]!
        let company = markerData!["company"]!
        let email = markerData!["email"]!
        let phone_ext = markerData!["phone_ext"]!
        
        infoWindow.nameLabel.text = "\(firstName) \(lastName)"
        infoWindow.companyNameLabel.text = "Company: \(company)"
        infoWindow.emailLabel.text = "Email: \(email)"
        infoWindow.phoneLabel.text = "Phone: \(phone_ext)"
        
//        infoWindow.addressLabel.text = address as? String
//        infoWindow.priceLabel.text = "$\(String(format:"%.02f", (rate as? Float)!))/hr"
//        infoWindow.availibilityLabel.text = "\(convertMinutesToTime(minutes: (fromTime as? Int)!)) - \(convertMinutesToTime(minutes: (toTime as? Int)!))"
        // Offset the info window to be directly above the tapped marker
        infoWindow.center = mapView.projection.point(for: location)
//        infoWindow.center.y = infoWindow.center.y - 82
        self.view.addSubview(infoWindow)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
//            infoWindow.center.y = infoWindow.center.y - 82
        }
    }
        
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
}

extension MapViewController : MapMarkerDelegate{
    func didTapInfoButton(data: NSDictionary) {
            print(data)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyLeadDetailVC") as! MyLeadDetailVC
        vc.isAPIRequired = true
        let objLeadList = LeadList()
        objLeadList.leadId = "\(data["leadId"] ?? "")"
        vc.objLeadList = objLeadList
//        vc.delegateRefresh = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
