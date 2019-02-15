//
//  SignUp.swift
//  PurdueClass
//
//  Created by SH on 2/14/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class SignUp: UIViewController {

    @IBOutlet weak var SignButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SignButton.layer.cornerRadius = 20
        view.addBackground()	
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"Background"))
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var C_Password: UITextField!
    @IBOutlet weak var SecurityQ: UITextField!
    @IBOutlet weak var Answer: UITextField!
    
    @IBOutlet weak var Information: UILabel!
    
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        //let username:String! = Username.text
        //let password:String! = Password.text
        //let c_password:String! = C_Password.text
        //let answer:String! = Answer.text
        
        if Username.text == "" || Password.text == ""
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
