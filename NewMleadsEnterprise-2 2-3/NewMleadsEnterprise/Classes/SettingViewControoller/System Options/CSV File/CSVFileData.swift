//
//  CSVFileData.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 05/12/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class CSVFileData: UIViewController {
    
    var dataShow = "Note: .CSV file will be imported with predefined sample format only.\n\nSteps to save .CSV file with sample format:\n\nStep 1: Connect your iPad or iPhone to iTunes on your desktop computer and select “Apps” Section.\n\nStep 2: In Apps Section, there will be list of file sharing applications. Select “MLeads” app.\n\nStep 3: From MLeads document list, select “import leads – sample file.csv” file, and save it on your laptop or desktop folder.\n\nStep 4: Add your leads information into the file according to the format defined in the sample file. After you done enter the leads information, please save the file under a different name.\n\nStep 5: Drag and drop the file which you just created with your data into “MLeads Document” List.\n\nStep 6: Now go back to the MLeads application on your device and import the leads information using your .csv file."

    @IBOutlet weak var lblCSV: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblCSV.text = self.dataShow
    }

    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
