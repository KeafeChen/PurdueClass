//
//  CourseCell.swift
//  PurdueClass
//
//  Created by H. on 2/10/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    
    @IBOutlet weak var courseTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    func configureCell(title: String){
        courseTitle.text = title
    }
    
}
