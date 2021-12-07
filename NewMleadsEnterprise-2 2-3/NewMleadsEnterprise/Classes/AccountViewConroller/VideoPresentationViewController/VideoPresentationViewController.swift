//
//  VideoPresentationViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 20/01/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI

class VideoPresentationViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var ContainerView: UIView!
    @IBOutlet var StackView: UIStackView!
    @IBOutlet var btnVideoPlay: UIButton!
    
    @IBOutlet var btnVideoDetail: UIButton!
    @IBOutlet var btnvideoEdit: UIButton!
    @IBOutlet var btnVideoMail: UIButton!
    @IBOutlet var btnVideoDelete: UIButton!
    
    @IBOutlet var lblVideoPlay: UILabel!
    @IBOutlet var lblVideoDetail: UILabel!
    @IBOutlet var lblVideoEdit: UILabel!
    @IBOutlet var lblVideoMail: UILabel!
    @IBOutlet var lblVideoDelete: UILabel!
    
    var Vname = String()
    
    var isDeleteProfile =  Bool()
    var isVideoList = Bool()
    
    var arrVideoList = NSMutableArray()
    var arrVideoListCreatedTiemStemp = String()
    //var arrVideoList = [String]()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var objVideoList : VideoProfileDetail = VideoProfileDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Video Presentation"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.btnAddVideoAction(_:)))
        if isVideoList{
            //MARK: WEB SERVICES CALL...
            let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "action": "list" as AnyObject]
        
            //ProgressBar Viewable...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
            webService.doRequestPost(GET_VideoProfile_Link_URL, params: param, key: "videoLinks", delegate: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       // ContainerView.isHidden = true
        StackView.isHidden = true
        isDeleteProfile = false
        callWebService()
        
}
     
    //MARK:- Webservices Custom Function Call Method...
    func callWebService()
    {
        if isVideoList{
            //MARK: WEB SERVICES CALL...
            let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "action": "list" as AnyObject]
            //ProgressBar Viewable...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

            webService.doRequestPost(GET_VideoProfile_Link_URL, params: param, key: "videoLinks", delegate: self)
        }
    }
    //MARK:- Button Action Method...
    @IBAction func btnPlayVideoAction(_ sender: Any) {
        
        print("Click The Play Button...")
        let vLink = objVideoList.videoLink
        print(vLink!)
        UIApplication.shared.openURL(URL(string: vLink!)!)
    }
    
    @IBAction func btnDetailVideoAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"VideoViewDetailViewController") as! VideoViewDetailViewController
        vc.objVideoLink = objVideoList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddVideoAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoProfileViewController") as! AddVideoProfileViewController
        vc.isAddVideoProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEditVideoAction(_ sender: Any) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoProfileViewController") as! AddVideoProfileViewController
        
        vc.isEditVideoProfile = true
        vc.objVideoProfile = objVideoList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMailVideoAction(_ sender: Any) {
        
        let param = ["template_code":"VIDEO_PROFILE_MAIL",
                     "userId":objLoginUserDetail.createTimeStamp!,
                     "video_id": objVideoList.created_TimeStamp]
        //ProgressBar Viewable...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(Get_EmailTamplate_API, params: param as [String : AnyObject], key: "getEmailTemplate", delegate: self)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "") as!
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDeleteVideoAction(_ sender: AnyObject) {
    
        if isDeleteProfile{
        //let buttonTag = sender.tag
            let videoLinkID = objVideoList
            arrVideoListCreatedTiemStemp = videoLinkID.created_TimeStamp!
        //print(videoLinkID)
            
            let alertController = UIAlertController(title: "", message: "Are you sure you want to delete the Video Presentation?", preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Delete Video Presentation")
            alertController.setValue(attributedString, forKey: "attributedTitle")
            let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler:{(UIAlertAction) in
                print("Cancelled...!")
            })
            let DeleteAct = UIAlertAction(title: "Delete", style: .default, handler:{ (UIAlertAction) in
                print("Delete Video Presentation...!")
                
                if self.isDeleteProfile{
                //WEbService Parameter....
                let param:[String : String] = ["create_timestamp": self.arrVideoListCreatedTiemStemp,
                                               "action": "delete" ]
                
                //Progress Bar Loading...
                let size = CGSize(width: 30, height: 30)
                self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                
                self.webService.doRequestPost(GET_VideoProfile_Link_URL, params: param as [String : AnyObject], key: "videoLinks", delegate: self)
                }
            })
            
            cancelAct.setValue(Utilities.alertButtonColor(), forKey: "titleTextColor")
            DeleteAct.setValue(Utilities.alertButtonColor(), forKey: "titleTextColor")
            alertController.addAction(cancelAct)
            alertController.addAction(DeleteAct)
            self.present(alertController, animated: true, completion: {
                //            print("completion block")
            })
        }
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "") as!
//        self.navigationController?.pushViewController(vc, animated: true)
 
 
    }
}
//MARK:- UITableView Delegate Method...
extension VideoPresentationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objVideoList : VideoProfileDetail
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoProfile", for: indexPath)
        objVideoList = arrVideoList[indexPath.row] as! VideoProfileDetail
        let lblVideoName : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        lblVideoName.text = objVideoList.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //To Be Process...
        if arrVideoList.count > 0{
//            let selectedIndexForVideoList = arrVideoList[indexPath.row] as! VideoProfileDetail
//            let list =  selectedIndexForVideoList.name!
//            print(selectedIndexForVideoList)
//            print(list)
            
            //let tempVList = arrVideoList[indexPath.row] as! VideoProfileDetail
           // let selectedName = tempVList.name
            // print(selectedName!)
            objVideoList = arrVideoList[indexPath.row] as! VideoProfileDetail
            let selectedObjValue = objVideoList.name
            print(selectedObjValue)
            isDeleteProfile = true
            //ContainerView.isHidden = false
            StackView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK:- WebServices Delegate MEthod....
extension VideoPresentationViewController: WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
           stopAnimating()
           
        if apiKey == Get_EmailTamplate_API
        {
            let result = handleWebService.getEmailTemplate(response)
            stopAnimating()
            let mailComposeViewController = configuredMailComposeViewController(result: result)
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        else if isDeleteProfile == true
        {
            if apiKey == GET_VideoProfile_Link_URL
            {
                let json = JSON(data: response)
                let result = json["video_manupulation"]
                                                      
                if result["status"] == "YES"
                {
                    let alert = UIAlertController(title: "", message: "Video Profile Delete Successfully.",  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Delete Video Profile!")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    //_ = self.navigationController?.popViewController(animated: true)
                        self.callWebService()
                        self.isDeleteProfile = false
                    })
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                                                          
                }else
                {
                    let alert = UIAlertController(title: "", message: "Video PRofile Not Delete.",  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Delete Video Profile!")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                                                          
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                }
            }
        }
        else if isVideoList
        {
            if apiKey == GET_VideoProfile_Link_URL
            {
                let result = handleWebService.handleGetVideoProfilePresentation(response)
                if result.Status
                {
                    print("call WEbservices...")
                    arrVideoList = result.arrVideo
                    print(arrVideoList)
                    tableView.reloadData()
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

//MARK:- Email Delegate MEthod...
extension VideoPresentationViewController: MFMailComposeViewControllerDelegate{
    //,MFMailComposeViewControllerDelegate
    
        func configuredMailComposeViewController(result : JSON) -> MFMailComposeViewController {
               let mailComposerVC = MFMailComposeViewController()
            print("Check the MAil Sucess CAll")
               mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
              // let mailto = objLoginUserDetail.email
               //mailComposerVC.setToRecipients([mailto!])
               var subject = result["template_subject"].string
              // subject = subject?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
               mailComposerVC.setSubject(subject! as String)
               var messagebody = result["template_body"].string
            
                //messagebody = MessageBody()
                messagebody = messagebody?.replacingOccurrences(of: "&amp;", with: "&")
                messagebody = messagebody?.replacingOccurrences(of: "&lt;", with: "<")
                messagebody = messagebody?.replacingOccurrences(of: "&gt;", with: ">")
                messagebody = messagebody?.replacingOccurrences(of: "&apos;", with: "'")
                messagebody = messagebody?.replacingOccurrences(of: "&quot;", with: "\"")
                messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                messagebody = messagebody?.replacingOccurrences(of: "###VFILE_PATH###", with:" \(objVideoList.videoLink!)")
               
              // messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: MessageBody())
               
            
               // messagebody = messagebody?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
               
               print("topBody:\(messagebody!)")
             
               messagebody = messagebody?.replacingOccurrences(of: "\n", with: "<br />")
               messagebody = messagebody?.replacingOccurrences(of: "\r", with: "")
               messagebody = messagebody?.replacingOccurrences(of: "\t", with: "")
               
               mailComposerVC.setMessageBody(messagebody! , isHTML: true)
               
           
            
              /* if let image = imgQRCode.image  {
                let imageData: NSData = image.pngData()! as NSData
                mailComposerVC.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "QRCard.png")
               }
            */
            
            
               return mailComposerVC
           }
        
        func showSendMailErrorAlert() {
                
            let alert = UIAlertController(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Could Not Send Email")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
            alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
        }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            switch (result)
            {
            case .cancelled:
                print("Mail cancelled");
                break;
            case .saved:
                print("Mail saved");
                break;
            case .sent:
                print("Mail sent");
                
                let alert = UIAlertController(title: "", message: "Email sent successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Success")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)

                break;
            case .failed:
                print("Mail sent failure:, \(error?.localizedDescription)");
                
                let alert = UIAlertController(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Could Not Send Email")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
                
                break;
            }
            controller.dismiss(animated: true, completion: nil)
        }
}
