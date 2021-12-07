

import UIKit

class LeadEventTblCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMain.setborder(0.5, _color: UIColor.lightGray)
        self.viewMain.setCornerRadius_Extension(4.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
