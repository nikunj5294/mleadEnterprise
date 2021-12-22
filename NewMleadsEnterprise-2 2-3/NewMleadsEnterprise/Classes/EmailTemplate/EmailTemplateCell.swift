//
//  EmailTemplateCell.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 22/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class EmailTemplateCell: UITableViewCell {

    @IBOutlet weak var lblSubject: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSubject.superview!.layer.cornerRadius = 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
