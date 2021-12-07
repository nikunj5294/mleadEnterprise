//
//  AddLeadViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 09/07/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class AddLeadViewController: UIViewController {
    
    var imagePicker = UIImagePickerController()
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        self.navigationItem.title = "ADD Lead"
        self.findHamburguerViewController()?.gestureEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let back = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        let navigationVc = UINavigationController(rootViewController: back)
        present(navigationVc, animated: true, completion: nil)
    }
    
    @IBAction func btnAddLeadAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            funcOpenImagePicker()
//            let zBarVC = ZBarReaderViewController()
//            zBarVC.readerDelegate = self
//            zBarVC.readerView.session.sessionPreset = .iFrame1280x720
//            self.present(zBarVC, animated: true, completion: nil)
            return
        case 1:
            print("1")
        case 2:
            print("2")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let speakView = storyboard.instantiateViewController(withIdentifier: "SpeakViewController") as! SpeakViewController
            self.navigationController?.pushViewController(speakView, animated: true)
        case 3:
            print("3")
        case 4:
            print("4")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanBusinessLeadViewController") as! ScanBusinessLeadViewController
            vc.strLeadType = "4"
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            print("5")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let speakView = storyboard.instantiateViewController(withIdentifier: "QuickRecordViewController") as! QuickRecordViewController
            self.navigationController?.pushViewController(speakView, animated: true)
        case 6:
            //print("6")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuickNoteViewController") as! QuickNoteViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            print("7")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanBusinessLeadViewController") as! ScanBusinessLeadViewController
            vc.isTypeLead = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("Done")
        }
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageProfileViewController") as! ImageProfileViewController
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    func funcOpenImagePicker(){
        
        let alert = UIAlertController(title: "Mleads", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Select Picture", style: .default, handler: { _ in
                self.openGallary()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension AddLeadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageView = UIImage()
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                print("done")
            selectedImageView = pickedImage
        }else if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageView = pickedImage
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanBusinessLeadViewController") as! ScanBusinessLeadViewController
        vc.imageSelectedBussiness = selectedImageView
        vc.strLeadType = "5"
        navigationController?.pushViewController(vc, animated: true)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
