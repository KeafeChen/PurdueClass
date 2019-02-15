//
//  ViewController.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import Moya
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS

class ViewController: UIViewController {

    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var ForgetButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoginButton.layer.cornerRadius = 20
        self.RegisterButton.layer.cornerRadius = 20
        self.ForgetButton.layer.cornerRadius = 20
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:b3912726-6290-4b03-9457-021d6d836bea")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration

    
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var Test: UILabel!
    

    
    @IBAction func LoginButton(_ sender: Any) {
        let username:String! = Username.text
        let password:String! = Password.text
        if username == "" || password == ""{

            let alert = UIAlertController(title: "Sorry", message:"You have to Enter the username and password First", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
            return
        }else{
            DoLogin(username, password)
            //let showing = "Account: \(account!), Password:\(password!)"
            //Test.text = showing
        }
    }
    
    
    
    
    func DoLogin( _ username:String, _ psw:String){
        //request database
        LoginDone()
    }
    
    func LoginDone(){
        //Test.text = "Succeed!"
    }
    
    
   
    
}

