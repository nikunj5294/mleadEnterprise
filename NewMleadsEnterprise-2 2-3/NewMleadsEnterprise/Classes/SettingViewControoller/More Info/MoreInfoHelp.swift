//
//  MoreInfoHelp.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 01/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import Alamofire

class MoreInfoHelp: UIViewController {

    @IBOutlet weak var tbHelp: UITableView!
    @IBOutlet weak var AIView: UIActivityIndicatorView!
    
    var arrVideo : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.AIView.startAnimating()
        self.CallAPI()
    }
    
    func CallAPI(){
        Alamofire.request("https://www.myleadssite.com/MLeads9.7.22/getQuickTipVideoList.php", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in

                switch response.result {
                case .success(let json):
                    print(json)
                    self.AIView.stopAnimating()
                    DispatchQueue.main.async {

                        let data = response.result.value as! [String : Any]
                        let videoData = data["quickTipVideo"] as? [String:Any] ?? [:]
                        if !videoData.isEmpty{
                            self.arrVideo = videoData["quickTipVideoList"] as? [[String:Any]] ?? []
                            self.tbHelp.reloadData()
                        }

                   }
                case .failure(let error):
                    self.AIView.stopAnimating()
                    print(error)
                }
        }
    }


}

extension MoreInfoHelp : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoHelpDataCell", for: indexPath) as! MoreInfoHelpDataCell
        
        cell.lblName.text = self.arrVideo[indexPath.row]["video_title"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let UrlData = self.arrVideo[indexPath.row]["video_path"] as? String ?? ""
        UIApplication.shared.openURL(URL(string:UrlData)!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

class MoreInfoHelpDataCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    override class func awakeFromNib() {
        
    }
    
}
