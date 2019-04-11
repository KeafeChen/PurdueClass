//
//  addHW.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/3/22.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class addHW: UIViewController {

    @IBOutlet weak var submit_outlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        submit_outlet.addButtonDesign()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var description1: UITextField!
    
    @IBOutlet weak var date: UITextField!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is homework{
            let vc = segue.destination as? homework
            vc?.newDescription = description1.text!
            vc?.newDate = date.text!
        }
        
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
