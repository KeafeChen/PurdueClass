//
//  AddNewHw.swift
//  PurdueClass
//
//  Created by Sun on 3/18/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class AddNewHw: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var descriptionOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UITextField!
    @IBAction func backbutton(_ sender: Any) {
    }
    
    @IBAction func descriptionTextField(_ sender: Any) {
        
    }
    
    @IBAction func dueTextField(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HWPage{
            let vc = segue.destination as? HWPage
            vc?.newDescription = descriptionOutlet.text!
            vc?.newDate = dateOutlet.text!
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
