//
//  SystemOptionAddCustomLead.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 03/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects

class SystemOptionAddCustomLead: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtLeadStatus: HoshiTextField!
    @IBOutlet weak var imgSelectLead: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func SelectLead(_ sender: Any) {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (ImageData) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                cameraPicker.sourceType = .camera
                cameraPicker.allowsEditing = true
                self.present(cameraPicker, animated: true, completion: nil)
            }
            else
            {
                //let _ = Alert(title: "Alert", msg: "Camera not Available", vc: self)
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (ImageData) in
            cameraPicker.sourceType = .photoLibrary
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (Action) in
        }))
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            actionSheet.popoverPresentationController?.sourceView = sender as! UIView
            actionSheet.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            actionSheet.popoverPresentationController?.permittedArrowDirections = .up
        }
        else
        {
            
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Get ImagePicker Method
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print(info)
            picker.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
            let image = info[UIImagePickerController.InfoKey.editedImage]! as! UIImage
            self.imgSelectLead.image = image
    //        let imageData : UIImage = resizeImage(image: image)
    //        //let url = UploadImage
    //        let param = ["imgUploader":""] as [String:Any]
    //            let data:Data = (imageData).pngData()!
            //self.AIView.startAnimating()
                //self.requestWithDriver(endUrl: url, imageData: data, parameters: param)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func Save(_ sender: Any) {
        if validation(){
            //        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,"leadStatus":"" as AnyObject,"type":"" as AnyObject,"statusId":"" as AnyObject,"id":"" as AnyObject]
            //
            //                WebServiceCH.shared.RequesURL(ServerURL.Add, Perameters: param, showProgress: true) { (result, status) in
            //
            //                    debugPrint("result",result)
            //                }
            //                failure: { (error) in
            //                    debugPrint("error",error)
            //                }
        }
    }
    
    func validation() -> Bool {
        
        if self.txtLeadStatus.text!.isEmpty{
            ShowAlert(title: "", message: "Please enter Lead status", buttonTitle: "Ok", handlerCB: nil)
            return false
        }
        return true
    }
}

