//
//  BlockCollectionViewCell.swift
//  PurdueClass
//
//  Created by SH on 4/14/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class BlockCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var block_label: UILabel!
    
    func configureCell(title: String?){
        print(title)
        block_label.text = title ?? ""
    }
}
