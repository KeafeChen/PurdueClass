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
    
    @IBOutlet weak var block_button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(title: String?){
        block_button.setTitle(title, for: .normal)
    }
    
   
}
