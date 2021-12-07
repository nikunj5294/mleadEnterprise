//
//  StringPopOver.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 26/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import UIKit

public class StringPickerPopOver :AbstractPopover,UIPickerViewDataSource,UIPickerViewDelegate{
    
    class var sharedInstance : StringPickerPopOver{
        struct Static {
            static let instance : StringPickerPopOver = StringPickerPopOver()
        }
        return Static.instance
    }
    
    var choices: [String] = []
    var selectedRow: Int = 0
    var displayStringFor: ((String?)->String?)? = nil
    var fontSize: CGFloat = 18.0
    
    
    public class func appearFrom(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, title: String?, choices:[String], displayStringFor:((String?)->String?)? = nil, initialRow:Int, doneAction: ((Int, String)->Void)?, cancelAction: (()->Void)?){
        sharedInstance.choices = choices
        sharedInstance.selectedRow = initialRow
        sharedInstance.displayStringFor = displayStringFor
        
        guard let navigationController = sharedInstance.configureNavigationController(originView, baseView: baseView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        if let contentViewController = navigationController.topViewController as? StringPickerPopOverViewController {
            
            contentViewController.doneAction = doneAction
            contentViewController.cancleAction = cancelAction
            
            navigationController.popoverPresentationController?.delegate = contentViewController
        }
        navigationController.navigationBar.barTintColor = UIColor(hexString: "02a8F6")
        baseViewController.present(navigationController, animated: true, completion: nil)
    }
    
    override func storyboardName() -> String {
        return "StringPickerPopOver"
    }
    
    //MARK: UIPickerView Delegate Method
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let d = displayStringFor {
            
            return d(choices[row])
        }
        return choices[row]
    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = choices[row]
        let title = NSAttributedString(string: data, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)])
        label!.attributedText = title
        label!.textAlignment = .center
        return label!
        
    }
    
}
