//
//  ProfileImageViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 06/09/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
class ImageProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NVActivityIndicatorViewable {

    @IBOutlet var btnSelectPicture: UIButton!
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var image = UIImage()
    var isFromSideMenu = false
    @IBOutlet weak var btnShowProfile: RoundedButton!
    
    
    
    @IBAction func imgUpButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isFromSideMenu{
            btnShowProfile.isHidden = true
        }
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            if (touch.view == self.view) {
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    
    @IBAction func btnTakePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            cameraPicker.allowsEditing = false
            self.present(cameraPicker, animated: true, completion: nil)
        }
        else
        {
            //let _ = Alert(title: "Alert", msg: "Camera not Available", vc: self)
            print("Camera not available")
        }
    }
    
    @IBAction func btnSelectImageAction(_ sender: Any) {
        // profile_image
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        cameraPicker.allowsEditing = true
        self.present(cameraPicker, animated: true, completion: nil)
        
    }
    
    @IBAction func btnShowProfileClicked(_ sender: Any) {
        
        let showProfileVC = self.storyboard?.instantiateViewController(identifier: "ShowProfileViewController") as! ShowProfileViewController
        showProfileVC.modalPresentationStyle = .fullScreen
        showProfileVC.imgProfile = image
        self.present(showProfileVC, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        picker.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async { [self] in
            
            var imageObj = UIImage()
            
            if (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) != nil{
                imageObj = info[UIImagePickerController.InfoKey.editedImage]! as! UIImage
            }else{
                imageObj = info[UIImagePickerController.InfoKey.originalImage]! as! UIImage
            }
            
            self.JsonMake_UploadImage_request(SelectImage: imageObj)
            
            let imageDataDict:[String: UIImage] = ["image": imageObj]

              // post a notification
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedthephoto"), object: nil, userInfo: imageDataDict)
              // `default` is now a property, not a method call
            
            
            let param:[String : AnyObject] = [//"user_id" : objLoginUserDetail.createTimeStamp! as AnyObject,
                                              "user_id": objLoginUserDetail.createTimeStamp! as AnyObject,
                                              "profile_image":"" as AnyObject,
                                              ]
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            self.CareImageUploadAPI(image: imageObj)
            
//            webService.doRequestPost(UPDATE_USER_API_URL, params: param, key: "updateUser", delegate: self)
            
            
            
            
        }
    }
    
    func CareImageUploadAPI(image:UIImage) {
        
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(objLoginUserDetail.createTimeStamp!.data(using: .utf8)!, withName: "userId")
            multipartFormData.append("P".data(using: .utf8)!, withName: "type")
            multipartFormData.append((image.jpegData(compressionQuality: 0.5))!, withName: "profile_image", fileName: "user.jpg", mimeType: "image/jpeg")
            
        },
        to:WEBSERVICE_URL+UploadProfileAndWhiteLogo,
        method:.post,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.stopAnimating()
                    if response.response?.statusCode == 200{
                        print(response)
                        if let jsonResponse = response.result.value as? [String:Any]{
                            print(response.result.value!)
                            if let code = jsonResponse["addLogo"] as? [String:Any]{
                                if let dataResponse = code["status"] as? String, dataResponse == "YES"{
                                    
                                    DispatchQueue.main.async {
                                        let size = CGSize(width: 30, height: 30)
                                        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                                    }
                                    
                                    let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp as AnyObject]
                                    self.webService.doRequestPost(GET_USER_DETAIL, params: param, key: "userDetail", delegate: self)
                                }
                            }
                        }
                    }else{
                        if let jsonResponse = response.result.value as? [String:Any]{
//                            self.ShowAlertVC(title: "", subTitle : jsonResponse["message"] as? String ?? "Something went wrong. Please try again.") {}
                        }else{
//                            self.ShowAlertVC(title: "", subTitle : "Something went wrong. Please try again.") {}
                        }
                    }
                }
            case .failure(let encodingError):
                self.stopAnimating()
                print(encodingError)
            }
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func JsonMake_UploadImage_request(SelectImage:UIImage)
        {
            
            var param = [String:String]()
            param["user_id"] = objLoginUserDetail.createTimeStamp!
            param["profile_image"] = ""
        
            var paramImages = Dictionary<String, [UIImage]>()
            var imgSelected : [UIImage] = []
            imgSelected.append(SelectImage)
            if imgSelected.count != 0
            {
                paramImages = ["profile_image" : imgSelected]
            }
            
            debugPrint("param",param)
        
        WebServiceCH.shared.webRequestForMultipleImages(DictionaryImages:paramImages as NSDictionary, urlString: WEBSERVICE_URL + UPDATE_USER_API_URL, Perameters: param, completion: { [self] (response, status) in
                debugPrint("Signin :: ", response)
                
            let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp as AnyObject]
            self.webService.doRequestPost(GET_USER_DETAIL, params: param, key: "userDetail", delegate: self)
                
            }) { (err) in
                
                debugPrint(err.localizedDescription)
                ShowAlert(title: "", message: ToString(err.localizedDescription), buttonTitle: "Ok", handlerCB: nil)
            }
        }
}

extension ImageProfileViewController : WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_USER_DETAIL
        {
            let result = handleWebService.handleUserDetails(response)
            
            if result.Status
            {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: result.UserDetail)
                USERDEFAULTS.set(encodedData, forKey: LOGIN_USER_Detail)
                USERDEFAULTS.synchronize()
                
                let decodedUserDetail = USERDEFAULTS.object(forKey: LOGIN_USER_Detail) as! Data
                objLoginUserDetail = NSKeyedUnarchiver.unarchiveObject(with: decodedUserDetail) as! UserDetail!
                
                let alert = UIAlertController(title: "", message: "User Updated Successfully",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Update User")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
                    DispatchQueue.main.async {
                        let decodedUserDetail = USERDEFAULTS.object(forKey: LOGIN_USER_Detail) as! Data
                        objLoginUserDetail = NSKeyedUnarchiver.unarchiveObject(with: decodedUserDetail) as! UserDetail!
                        print("objLoginUserDetail Model Data : \(objLoginUserDetail)")
                        self.dismiss(animated: true, completion: nil)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
                
            }
        }
    }
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
    }
}


 
 

