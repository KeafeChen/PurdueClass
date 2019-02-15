//
//  ClassInformation.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import Moya


class ClassInformation: UIViewController {

    var categoryList: [String]!
    @IBOutlet var categoryButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground()    
        // Do any additional setup after loading the view.
    }
    enum Categories: String{
        case department = "Department"
        case subject = "Subject"
        
    }
    @IBAction func categoryTaped(_ sender: UIButton) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
        guard let title = sender.currentTitle, let category = Categories(rawValue: title) else{
            return
        }
        switch category {
        case .department:
            print("Department")
        case .subject:
            print("Subject")
        }
    }
    
    @IBAction func handleSelection(_ sender: UIButton) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
