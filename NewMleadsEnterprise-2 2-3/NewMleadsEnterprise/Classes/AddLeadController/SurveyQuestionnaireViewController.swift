//
//  SurveyQuestionnaireViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 26/04/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

protocol passLeadSurveyQuestionsDelegate {
    func passSurveyQuestions(stackLevelInterest:Int, stackBusinessPotential:Int, stacktimeFrame:Int, stackFollowUp:Int, stackEmailCatelog:Int, stackEmailLiterature:Int, stackEmailQuote:Int, stackSalesCall:Int, stackScheduleDemo:Int, stackProvidesSamples:Int, stackImmediateNeed:Int, stackPurchasingSamples:Int, stackHasFinalSay:Int, stackRecommanded:Int)
}

class SurveyQuestionnaireViewController: UIViewController {

    @IBOutlet weak var stackLevelInterest: UIStackView!
    @IBOutlet weak var stackBusinessPotential: UIStackView!
    @IBOutlet weak var stacktimeFrame: UIStackView!
    @IBOutlet weak var stackFollowUp: UIStackView!
    @IBOutlet weak var stackEmailCatelog: UIStackView!
    @IBOutlet weak var stackEmailLiterature: UIStackView!
    @IBOutlet weak var stackEmailQuote: UIStackView!
    @IBOutlet weak var stackSalesCall: UIStackView!
    @IBOutlet weak var stackScheduleDemo: UIStackView!
    @IBOutlet weak var stackProvidesSamples: UIStackView!
    @IBOutlet weak var stackImmediateNeed: UIStackView!
    @IBOutlet weak var stackPurchasingSamples: UIStackView!
    @IBOutlet weak var stackHasFinalSay: UIStackView!
    @IBOutlet weak var stackRecommanded: UIStackView!
    
    var delegateSurveyQuestion:passLeadSurveyQuestionsDelegate?
    
    var strLevelInterest = 1
    var strBusinessPotential = 1
    var strtimeFrame = 1
    var strFollowUp = 1
    var strEmailCatelog = 1
    var strEmailLiterature = 1
    var strEmailQuote = 1
    var strSalesCall = 1
    var strScheduleDemo = 1
    var strProvidesSamples = 1
    var strImmediateNeed = 1
    var strPurchasingSamples = 1
    var strHasFinalSay = 1
    var strRecommanded = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Survey Questionnaire"
        
        stackLevelInterest.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strLevelInterest{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackBusinessPotential.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strBusinessPotential{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stacktimeFrame.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strtimeFrame{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackFollowUp.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strFollowUp{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackEmailCatelog.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strEmailCatelog{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackEmailLiterature.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strEmailLiterature{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackEmailQuote.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strLevelInterest{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackSalesCall.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strSalesCall{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackScheduleDemo.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strScheduleDemo{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackProvidesSamples.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strProvidesSamples{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackImmediateNeed.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strImmediateNeed{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackPurchasingSamples.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strPurchasingSamples{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackHasFinalSay.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strHasFinalSay{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }
        
        stackRecommanded.subviews.forEach { (viewObj) in
            if let btn = viewObj as? UIButton{
                if viewObj.tag == strRecommanded{
                    btn.setImage(UIImage(named: "radio-button-selected"), for: .normal)
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClickedLevelOfInterest(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strLevelInterest = sender.tag
        
    }
    
    @IBAction func btnClickedBusinessPotential(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strBusinessPotential = sender.tag
        
    }
    
    @IBAction func btnClickedTimeFrame(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strtimeFrame = sender.tag
    }

    @IBAction func btnClickedFollowTimeFrame(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strFollowUp = sender.tag
        
    }
    
    @IBAction func btnClickedEmailCatelog(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strEmailCatelog = sender.tag
    }
    
    @IBAction func btnClickedEmailLiterature(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strEmailLiterature = sender.tag
    }
    
    @IBAction func btnClickedEmailQuote(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strEmailQuote = sender.tag
    }
    
    @IBAction func btnClickedSalesPersonCall(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strSalesCall = sender.tag
    }
    
    @IBAction func btnClickedScheduleDemo(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strScheduleDemo = sender.tag
    }
    
    
    @IBAction func btnClickedProvideSamples(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strProvidesSamples = sender.tag
    }
    
    @IBAction func btnClickedIntermediateNeed(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strImmediateNeed = sender.tag
        
    }
    
    @IBAction func btnClickedPurchasingManager(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strPurchasingSamples = sender.tag
        
    }
    
    @IBAction func btnClickedHasFinalSay(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strHasFinalSay = sender.tag
    }
    
    @IBAction func btnClickedRecommend(_ sender: UIButton) {
        
        if let stackObj = sender.superview as? UIStackView{
            stackObj.subviews.forEach { (viewObj) in
                if let btn = viewObj as? UIButton{
                    btn.setImage(UIImage(named: "radio-button-unselected"), for: .normal)
                }
            }
        }
        sender.setImage(UIImage(named: "radio-button-selected"), for: .normal)
        strRecommanded = sender.tag
    }
    
    // MARK: - Save Action

    @IBAction func btnSaveClicked(_ sender: Any) {
        
        delegateSurveyQuestion?.passSurveyQuestions(stackLevelInterest: strLevelInterest, stackBusinessPotential: strBusinessPotential, stacktimeFrame: strtimeFrame, stackFollowUp: strFollowUp, stackEmailCatelog: strEmailCatelog, stackEmailLiterature: strEmailLiterature, stackEmailQuote: strEmailQuote, stackSalesCall: strSalesCall, stackScheduleDemo: strScheduleDemo, stackProvidesSamples: strProvidesSamples, stackImmediateNeed: strImmediateNeed, stackPurchasingSamples: strPurchasingSamples, stackHasFinalSay: strHasFinalSay, stackRecommanded: strRecommanded)
        self.navigationController?.popViewController(animated: true)
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
