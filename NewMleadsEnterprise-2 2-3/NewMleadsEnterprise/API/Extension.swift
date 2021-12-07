//
//  Extension.swift
//  Wreckers
//
//  Created by MAC-1 on 28/01/20.
//  Copyright © 2020 MAC-1. All rights reserved.
//

import UIKit

extension UIViewController
{
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    func hideContentController(content: UIViewController) {
        
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
}

extension UIView
{
    func customCornerRadius(radius: CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func customBorder(borderWidth: CGFloat, borderColor : UIColor)
    {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }

}

extension UILabel {
    func calculateMaxLines(size : CGFloat) -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.fontMontserratRegular(size: size)], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttributes([NSAttributedString.Key.font : UIFont.fontMontserratBold(size: 11*ScreenScale), NSAttributedString.Key.foregroundColor : UIColor.RGBColor(R: 29, G: 27, B: 27, A: 0.8)], range: range)
        self.attributedText = attribute
    }
}

extension Date {

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}

extension UIColor
{
    static func RGBColor(R:CGFloat, G:CGFloat, B:CGFloat, A:CGFloat) -> UIColor
    {
        return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
    }
}

extension UIFont
{
    static func fontMontserratBold(size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    
    static func fontMontserratMedium(size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Medium", size: size)!
    }

    static func fontMontserratRegular(size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }

    static func fontMontserratLight(size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Light", size: size)!
    }

    static func fontMontserratSemiBold(size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
}

extension UIButton {
    func underlineButton(text: String, customTxt : String) {
        
        let main_string = text
        let string_to_underline = customTxt

        let range = (main_string as NSString).range(of: string_to_underline)
       
        let attribute = NSMutableAttributedString.init(string: text)
        attribute.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor : UIColor.RGBColor(R: 29, G: 27, B: 27, A: 0.8)], range: range)
        attribute.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.RGBColor(R: 29, G: 27, B: 27, A: 1.0)], range: NSRange(location: 0, length: main_string.count))

        self.setAttributedTitle(attribute, for: .normal)
    }
}

extension UITableView {
    func indexPathForView(_ view: UIView) -> IndexPath?
    {
        return self.indexPathForRow(at: convert(view.center, from: view.superview))
    }
}

extension UIView {

        func addDashedBorder() {
            //Create a CAShapeLayer
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.RGBColor(R: 143, G: 143, B: 143, A: 1.0).cgColor
            shapeLayer.lineWidth = 1
            // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
            shapeLayer.lineDashPattern = [2,3]

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: self.frame.width, y: 0)])
            shapeLayer.path = path
            layer.addSublayer(shapeLayer)
        }
    
    func applyShadow( getRadius : CGFloat,  zeroOffset : CGSize = .zero, _ ShdColor : UIColor = .black, opac : Float = 0.16) {
           layer.shadowColor = ShdColor.cgColor
           layer.shadowRadius = getRadius
           layer.shadowOpacity = opac
           layer.shadowOffset = zeroOffset
           layer.masksToBounds = false
       }

    func giveShadowRadius()
    {
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 2)
        self.layer.shadowOpacity = 0.10
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 10
    }

    func setborder(_ width: CGFloat, _color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = _color.cgColor
    }
    
    func setCornerRadius_Extension(_ radius: CGFloat = 2.0) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func setCornerRaduisToRound() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
    
    func setShadowColor(_ color: UIColor = UIColor.lightGray) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 3
        
       
        
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
    }
    
    func setShadowColor(_ color: UIColor, radius : CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
    }
    
    func setButoonShaownoRadious() {
        
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
    }
    
    func setButtonShadowWithoutRadious(_ color:UIColor){
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
    }
    
    func setBottomShadow(_ color:UIColor, corner_radius: CGFloat) {
        
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = corner_radius
        self.layer.shadowColor = color.cgColor
    }
    
 func roundCorners(corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
    }
    
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    func containsOnlyDigits() -> Bool
    {
        
        let notDigits = NSCharacterSet.decimalDigits.inverted
        
        if rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
        {
            return true
        }
        
        return false
    }
    
    func toDouble() -> Double?
    {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}


import UIKit

var creditCardFormatter : CreditCardFormatter
{
    return CreditCardFormatter.sharedInstance
}

class CreditCardFormatter : NSObject
{
    static let sharedInstance : CreditCardFormatter = CreditCardFormatter()

    func formatToCreditCardNumber(isAmex: Bool, textField : UITextField, withPreviousTextContent previousTextContent : String?, andPreviousCursorPosition previousCursorSelection : UITextRange?) {
        var selectedRangeStart = textField.endOfDocument
        if textField.selectedTextRange?.start != nil {
            selectedRangeStart = (textField.selectedTextRange?.start)!
        }
        if  let textFieldText = textField.text
        {
            var targetCursorPosition : UInt = UInt(textField.offset(from:textField.beginningOfDocument, to: selectedRangeStart))
            let cardNumberWithoutSpaces : String = removeNonDigitsFromString(string: textFieldText, andPreserveCursorPosition: &targetCursorPosition)
            if cardNumberWithoutSpaces.count > 19
            {
                textField.text = previousTextContent
                textField.selectedTextRange = previousCursorSelection
                return
            }
            var cardNumberWithSpaces = ""
            if isAmex {
                cardNumberWithSpaces = insertSpacesInAmexFormat(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
            }
            else
            {
                cardNumberWithSpaces = insertSpacesIntoEvery4DigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
            }
            textField.text = cardNumberWithSpaces
            if let finalCursorPosition = textField.position(from:textField.beginningOfDocument, offset: Int(targetCursorPosition))
            {
                textField.selectedTextRange = textField.textRange(from: finalCursorPosition, to: finalCursorPosition)
            }
        }
    }

    func removeNonDigitsFromString(string : String, andPreserveCursorPosition cursorPosition : inout UInt) -> String {
        var digitsOnlyString : String = ""
        for index in stride(from: 0, to: string.count, by: 1)
        {
            let charToAdd : Character = Array(string)[index]
            if isDigit(character: charToAdd)
            {
                digitsOnlyString.append(charToAdd)
            }
            else
            {
                if index < Int(cursorPosition)
                {
                    cursorPosition -= 1
                }
            }
        }
        return digitsOnlyString
    }

    private func isDigit(character : Character) -> Bool
    {
        return "\(character)".containsOnlyDigits()
    }

    func insertSpacesInAmexFormat(string : String, andPreserveCursorPosition cursorPosition : inout UInt) -> String {
        var stringWithAddedSpaces : String = ""
        for index in stride(from: 0, to: string.count, by: 1)
        {
            if index == 4
            {
                stringWithAddedSpaces += " "
                if index < Int(cursorPosition)
                {
                    cursorPosition += 1
                }
            }
            if index == 10 {
                stringWithAddedSpaces += " "
                if index < Int(cursorPosition)
                {
                    cursorPosition += 1
                }
            }
            if index < 15 {
               let characterToAdd : Character = Array(string)[index]
                stringWithAddedSpaces.append(characterToAdd)
            }
        }
        return stringWithAddedSpaces
    }


    func insertSpacesIntoEvery4DigitsIntoString(string : String, andPreserveCursorPosition cursorPosition : inout UInt) -> String {
        var stringWithAddedSpaces : String = ""
        for index in stride(from: 0, to: string.count, by: 1)
        {
            if index != 0 && index % 4 == 0 && index < 16
            {
                stringWithAddedSpaces += " "

                if index < Int(cursorPosition)
                {
                    cursorPosition += 1
                }
            }
            if index < 16 {
                let characterToAdd : Character = Array(string)[index]
                stringWithAddedSpaces.append(characterToAdd)
            }
        }
        return stringWithAddedSpaces
    }

}
