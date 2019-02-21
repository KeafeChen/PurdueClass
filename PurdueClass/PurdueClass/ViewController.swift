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

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var ForgetButton: UIButton!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.LoginButton.alpha = 0.0
        self.RegisterButton.alpha = 0.0
        self.ForgetButton.alpha = 0.0
        self.Username.alpha = 0.0
        self.Password.alpha = 0.0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //For textfield
        UIView.animate(withDuration: 1, animations: {
            self.Username.alpha = 0.7
            self.Password.alpha = 0.7
        }, completion:nil)
        
        UIView.animate(withDuration: 2, animations: {
            self.LoginButton.alpha = 0.7
            self.RegisterButton.alpha = 0.7
            self.ForgetButton.alpha = 0.7
            self.LoginButton.addButtonDesign()
            self.RegisterButton.addButtonDesign()
            self.ForgetButton.addButtonDesign()
            
        }, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:b3912726-6290-4b03-9457-021d6d836bea")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    @IBOutlet weak var Test: UILabel!
    
    let dispatchGroup = DispatchGroup()
    var check = 0
    
    
    @IBAction func LoginButton(_ sender: Any) {
        let username:String! = Username.text
        let password:String! = Password.text
        self.check = 0
        if username == "" || password == ""{
            let alert = UIAlertController(title: "Sorry", message:"You have to Enter the username and password First", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
            return
        }else{
            verify()
            
            dispatchGroup.notify(queue: .main){
                if(self.check == 1){
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(username, forKey: "username")
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "home_with_tabbar") as! UIViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                }else if (self.check == 0){
                    let alert = UIAlertController(title: "Sorry", message:"The user does not exist", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
                    self.present(alert, animated: true){}
                } else {
                    let alert = UIAlertController(title: "Sorry", message:"The password is wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
                    self.present(alert, animated: true){}
                }
            }
        }
    }
    
    
    func verify(){
        dispatchGroup.enter()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        let userid:String = Username.text!
        let password:String = Password.text!
        
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
        ]
        
        queryExpression.expressionAttributeValues = [
            ":userId": userid,
        ]
        
        objectMapper.query(Account.self, expression: queryExpression, completionHandler:
            {(response: AWSDynamoDBPaginatedOutput?, error:Error?) -> Void in
                if let error = error{
                    print("Amazon Sever error \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("querying")
                    if(response != nil){
                        print("we got response")
                        if(response?.items.count == 0){
                            print("no such user")
                            self.check = 0;
                        }else{
                            for item in (response?.items)! {
                                if (item.value(forKey: "_password") != nil){
                                    if let p = item.value(forKey: "_password") as? String{
                                        if (p == password){
                                            self.check = 1
                                            break
                                        } else {
                                            self.check = 2
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.dispatchGroup.leave()
                }
        }
        )
    }
    
    
    
    
}

