//
//  HWcell.swift
//  PurdueClass
//
//  Created by Sun on 3/18/19.
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
        HWdate.text=hwcelldata.date
    }
    
    

}
