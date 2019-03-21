//
//  EventCell.swift
//  PurdueClass
//
//  Created by H. on 3/21/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var eventTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(title: String?){
        eventTitle.text = title ?? ""
    }
}
