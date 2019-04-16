//
//  ChangePassword.swift
//  PurdueClass
//
//  Created by SH on 2/18/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS

class ChangePassword: UIViewController {
    
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        DoneButton.addButtonDesign()
        CancelButton.addButtonDesign()
        // Do any additional setup after loading the view.
    }
    
    let dispatchGroup = DispatchGroup()
    var check = 0;
    
    
    @IBOutlet weak var CurrentPassword: UITextField!
    @IBOutlet weak var NewPassword: UITextField!
    @IBOutlet weak var C_NewPassword: UITextField!
    
    
    var username = UserDefaults.standard.string(forKey: "username")!
    var question = ""
    var answer = ""
    
    
    @IBAction func ChangePassword(_ sender: Any) {
        let currentPassword:String! = CurrentPassword.text
        let password:String! = NewPassword.text
        let c_password:String! = C_NewPassword.text
        
        if currentPassword == "" || password == "" || c_password == "" {
            let alert = UIAlertController(title: "Sorry", message:"You have to Enter all the information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
        } else if password.count < 8 {
            let alert = UIAlertController(title: "Sorry", message:"Password must be 8 characters at least", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
        } else if (password != c_password) {
            let alert = UIAlertController(title: "Sorry", message:"New password is not consist with the confirm password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
        } else {
            self.check = 0
            verify()
            
            dispatchGroup.notify(queue: .main){
                if(self.check == 1){
                    self.changePassword()
                }else if (self.check == 0){
                    let alert = UIAlertController(title: "Sorry", message:"The user does not exist", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
                    self.present(alert, animated: true){}
                } else {
                    let alert = UIAlertController(title: "Sorry", message:"the current password is wrong", preferredStyle: .alert)
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
        
        let currentPassword:String! = CurrentPassword.text
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
        ]
        
        queryExpression.expressionAttributeValues = [
            ":userId": username,
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
                                if let p = item.value(forKey: "_password") as? String{
                                    if (p == currentPassword){
                                        if let q = item.value(forKey: "_question") as? String{
                                            if let a = item.value(forKey: "_answer") as? String{
                                                self.question = q
                                                self.answer = a
                                                self.check = 1
                                            }
                                        }
                                    } else {
                                        self.check = 2
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
    
    
    
    func changePassword(){
        let currentPassword:String! = CurrentPassword.text
        let password:String! = NewPassword.text
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToDelete:Account = Account()
        
        itemToDelete._userId = username
        itemToDelete._password = currentPassword
        
        objectMapper.remove(itemToDelete, completionHandler:{(error: Error?) -> Void in
            if let error = error{
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("User data updated or saved initially")
        })
        
        let itemToCreate:Account = Account()
        
        itemToCreate._userId = username
        itemToCreate._password = password
        itemToCreate._question = question
        itemToCreate._answer = answer
        
        objectMapper.save(itemToCreate, completionHandler:{(error: Error?) -> Void in
            if let error = error{
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("User data updated or saved initially")
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.username, forKey: "username")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Profile") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }
        })
        
    }
    

    @IBAction func Cancel(_ sender: Any) {
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
