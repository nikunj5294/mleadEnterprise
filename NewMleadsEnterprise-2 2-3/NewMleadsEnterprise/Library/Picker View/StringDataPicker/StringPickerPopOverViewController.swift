//
//  StringPickerPopOverViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 26/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class StringPickerPopOverViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    var doneAction: ((Int, String)->Void)?
    var cancleAction: (()->Void)?
    
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = StringPickerPopOver.sharedInstance
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        UINavigationBar.appearance().barTintColor = .black
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "app_theme_color")
//        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let select = StringPickerPopOver.sharedInstance.selectedRow
        pickerView.selectRow(select, inComponent: 0, animated: true)
        
    }
    @IBAction func btnDoneClick(_ sender: Any) {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if !StringPickerPopOver.sharedInstance.choices.isEmpty{
            let selectString = StringPickerPopOver.sharedInstance.choices[selectedRow]
            doneAction!(selectedRow,selectString)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        cancleAction!()
        dismiss(animated: true, completion: nil)
    }
//    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
//        btnCancelClick()
//    }
    
    /// Popover appears on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
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
