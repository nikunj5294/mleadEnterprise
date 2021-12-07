//
//  MoreInfoPricing.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 30/11/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class MoreInfoPricing: UIViewController {

    @IBOutlet weak var lblManual: UILabel!
    @IBOutlet weak var lblAuto: UILabel!
    @IBOutlet weak var lblDisclosure: UILabel!
    
    var DataManual = "Initially we are offering free Account up to 100 Leads.\nWe are providing manual subscription functionality for user account to remain active as mention below.\nLength of Subscription - 3 months for $23.99\nLength of Subscription - 6 months for $47.99\nLength of Subscription - 12 months for $94.99"
    var DataAuto = "We are providing auto renewable functionality for user account to remain active as mention below.\nAuto renewable Subscription price structure and length of subscription is same as manual subscription plan.\nLength of Subscription - 3 months for $23.99\nLength of Subscription - 6 months for $47.99\nLength of Subscription - 12 months for $94.99\nWith this auto renewable functionality user subscription payment will be auto deducted from user's apple account. This subscription provides continuing use of all the features listed in the application description. 7 days prior to the expiration of subscription period , application will give alert to the user to renew the subscription with two buttons \"Renew\" Or \"Later\". When user clicks on \"Renew\" then user will go to In-App Purchase Listing View and user will purchase the subscription. When user clicks on \"Later\" then user will be able to Login to account and able to access the application for remaining days. After the subscription period is expired then app will show an alert to user \"Your subscription is expired.\" with two buttons \"Renew\" Or \"Later\", When user clicks on \"Renew\" then user will go to In-App Purchase Listing View and user will purchase the subscription. - When user clicks on \"Later\" then no action will perform. User will remain on Login page. - Payment will be charged to iTunes Account at confirmation of purchase"
    var DataDisclosure = "Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period - Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal - Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase - No cancellation of the current subscription is allowed during active subscription period - Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication.\nFor more information please review terms of use and privacy policy on below link"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblManual.text = self.DataManual
        self.lblAuto.text = self.DataAuto
        self.lblDisclosure.text = self.DataDisclosure
        
    }
   
    @IBAction func LinkTap(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://myleadssite.com/terms.php")! as URL)
    }
    
}
