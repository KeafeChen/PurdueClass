//
//  ForgetPassword.swift
//  PurdueClass
//
//  Created by SH on 2/13/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class ForgetPassword: UIViewController {

    @IBOutlet weak var ForgetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ForgetButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Answer: UITextField!
    @IBOutlet weak var N_Password: UITextField!
    @IBOutlet weak var C_Password: UITextField!
    
    @IBOutlet weak var Information: UILabel!
    
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ResetPassword(_ sender: Any) {
        //let username:String! = Username.text
        //let answer:String! = Answer.text
        //let password:String! = N_Password.text
        //let c_password:String! = C_Password.text
        
        if Username.text == "" || N_Password.text == ""
            || C_Password.text == "" || Answer.text == ""{

            let alert = UIAlertController(title: "Sorry", message:"You have to Enter the username and password First", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}

        } else {

            //let showing = "Username: \(username!), Password:\(password!), "
            //Information.text = showing
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
