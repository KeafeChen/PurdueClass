//
//  ViewController.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import Moya


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var Account: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var Test: UILabel!
    
    @IBAction func LoginButton(_ sender: Any) {
        let account:String! = Account.text
        let password:String! = Password.text
        if Account.text == "" || Password.text == ""{
            Test.text = "Please Enter the account or password.\n"
        }else{
            let showing = "Account: \(account!), Password:\(password!)"
            Test.text = showing
        }
    }
    
}

