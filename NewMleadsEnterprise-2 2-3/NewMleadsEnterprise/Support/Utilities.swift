//
//  Utilities.swift
//  NewMleadsEnterprise
//
//  Created by  on 07/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


class Utilities{
  
//    //Image On TextField...
//    class func ImageTextFeld: UITextField {
//        @IBInspectable var leftImage: UIImage{
//            didSet{
//                updateView()
//            }
//        }
//        @IBInspectable var leftPadding: CGFloat = 0{
//            didSet{
//                updateView()
//            }
//        }
//
//        func updateView(){
//            if let Image = leftImage{
//                leftViewMode = .always
//
//                let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
//            }
//        }
//    }
    
    class func showProgressHud(_ view: UIViewController)
    {
//        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
//        //SVProgressHUD.setForegroundColor(UIColor(red: 19.0/255, green: 128/255, blue: 191/255, alpha: 1.0))
//        SVProgressHUD.setForegroundColor(UIColor(red: 246/255, green: 152/255, blue: 34/255, alpha: 1.0))
//        SVProgressHUD.setBackgroundColor(UIColor(white: 0, alpha: 0.7))
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
//        SVProgressHUD.show(withStatus: "Loading...")
        //Progress Bar Loding...
        
    }
    
    
    
    class func alertAttribute(titleString:String) -> NSAttributedString
    {
        let attributedString = NSAttributedString(string: titleString, attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), //your font here
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "02a8F6")])

        return attributedString
    }
    
    class func alertButtonColor() -> UIColor {
        return UIColor(hexString: "02a8F6")
    }
    
    //Progress Bar
    class func showProgress(_ view: UIViewController)
    {
        
    }
    
    class func NevigationBackBtn(view:UIViewController,target:AnyObject,action:Selector,Image:UIImage) -> UIBarButtonItem
    {
        view.findHamburguerViewController()?.gestureEnabled = false
        let backAssociate:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let backIcon:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backIcon.contentMode = UIView.ContentMode.scaleAspectFit
        backIcon.image = Image
        backAssociate.addSubview(backIcon)
        
        backAssociate.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        let backViewForBarItem:UIBarButtonItem = UIBarButtonItem(customView: backAssociate)
        backViewForBarItem.tintColor = UIColor.black
        //        backViewForBarItem.tintColor = UIColor.white
        
        return backViewForBarItem
    }
    
    //Date Formatter
    class func dateFormatter(Date:String,FromString:String,ToString:String) -> String
    {
        var strDate = ""
        let dateFormatter = DateFormatter()
       
        dateFormatter.dateFormat = FromString
        if Date == "00/00/0000"
        {
            strDate = Date
        }
        else{
            let selectedDate = dateFormatter.date(from: Date)
            dateFormatter.dateFormat = ToString
            strDate = dateFormatter.string(from: selectedDate!)
        }
        return strDate
    }
    
    class func DateToStringFormatter(Date:Date,ToString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ToString
        let strDate = dateFormatter.string(from: Date)

        return strDate
    }
    
    class func StringToDateFormatter(DateString:String,FromString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FromString
        let date = dateFormatter.date(from: DateString)

        return date!
    }
    
    
}
//Hex Color
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
//Validation Email And Password...
extension String {
    
    //Encrypt string to sha512
    func sha512() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
    
    
    func HTMLtoNormalString() -> String
    {
        let htmlStringData = self.data(using: String.Encoding.utf8)
        //Vaishali
        let attributedOptions : [NSAttributedString.DocumentReadingOptionKey : Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html as AnyObject,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue as AnyObject
        ]
        //        let attributedOptions : [String: AnyObject] = [
        //            NSAttributedString.DocumentAttributeKey.documentType.rawValue: NSAttributedString.DocumentType.html as AnyObject,
        //            NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue: String.Encoding.utf8.rawValue as AnyObject
        //        ]
        // let atrributedHTMLString =  try! NSAttributedString(data: htmlStringData!, options: attributedOptions, documentAttributes: nil)
        let atrributedHTMLString =  try! NSAttributedString(data: htmlStringData!, options: attributedOptions, documentAttributes: nil)
        return atrributedHTMLString.string
    }
    
    
    //Valid Phone No.
    func isValidPhoneNo() -> Bool
    {
        //        let PhoneNo = self.data(using: String.Encoding.utf8)
        //        let PHONE_REGEX = "^\\s*([0-9-()+/. ]*)\\s*$"
        //
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        //
        //        let result =  phoneTest.evaluate(with: PhoneNo)
        //
        //        return result
        
        do {
            let regex = try NSRegularExpression(pattern: "^\\s*([0-9-()+/. ]*)\\s*$", options: .caseInsensitive)
            
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: NSCharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: self)
        }
    }
    
    //Validate WebsiteUrl
    
    var isValidateUrl : Bool{
        do {
            let urlRegEx = "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
            return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
        }
    }
    
    
    //validate PhoneNumber
    //    var isPhoneNumber: Bool {
    //
    //        do {
    //            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
    //            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
    //            if let res = matches.first {
    //                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
    //            } else {
    //                return false
    //            }
    //        } catch {
    //            return false
    //        }
    //
    //    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Date {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)

        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}
extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            textStorage.delegate = self
        }
    }

}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}
