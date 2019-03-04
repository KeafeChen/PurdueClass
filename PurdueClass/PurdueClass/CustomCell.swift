//
//  CustomCell.swift
//  PurdueClass
//
//  Created by Sun on 3/3/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell
{
    
    var substribeSwitch: UISwitch?
    var hwDescription: String?
    var dueDate: String?
   

    
    var hwDescriptionView : UITextView={
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
            return textView
        
    }()
    
    var dueDateView : UITextView={
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        self.addSubview(hwDescriptionView)
        self.addSubview(dueDateView)
        
       hwDescriptionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        hwDescriptionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        hwDescriptionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        hwDescriptionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
            dueDateView.leftAnchor.constraint(equalTo: hwDescriptionView.rightAnchor).isActive = true
            dueDateView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            dueDateView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
            dueDateView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let hwDescription = hwDescription{
            hwDescriptionView.text = hwDescription
        }
        if let dueDate = dueDate{
            dueDateView.text = dueDate
        }
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("init")
    }
}
