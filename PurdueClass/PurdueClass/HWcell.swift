//
//  HWcell.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/3/22.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class HWcell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var HWdate: UILabel!
    @IBOutlet weak var HWdescription: UILabel!
    // @IBAction func HWSwitch(_ sender: Any)
    
    func configureCell(hwcelldata: HWData){
        HWdescription.text=hwcelldata.description
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "MMMM-dd HH:mm"
        HWdate.text=dateFormattor.string(from: hwcelldata.date)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
