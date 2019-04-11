//
//  Profile.swift
//  PurdueClass
//
//  Created by SH on 2/18/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class Profile: UIViewController {
    
    @IBOutlet weak var UsernameDisplay: UITextView!
    
    @IBOutlet weak var ChangePassword: UIButton!
    
    @IBOutlet weak var LogoutButton: UIButton!
    
    
    @IBOutlet weak var classinfo: UIButton!
    @IBOutlet weak var homework: UIButton!
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var profile: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        ChangePassword.addButtonDesign()
        LogoutButton.alpha = 0.7
        
        // Do any additional setup after loading the view.
        UsernameDisplay.insertText(UserDefaults.standard.string(forKey: "username")!)
    }
    
    
    @IBAction func HomeButton(_ sender: Any) {
    }

    
    @IBAction func ClassButton(_ sender: Any) {
    }

    
    @IBAction func LogoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "username")
    }
    
    
    @IBAction func ChangePassword(_ sender: Any) {
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
