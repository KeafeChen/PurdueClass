//
//  SignUp.swift
//  PurdueClass
//
//  Created by SH on 2/14/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSCore

class SignUp: UIViewController {

    @IBOutlet weak var SignButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SignButton.layer.cornerRadius = 20
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:b3912726-6290-4b03-9457-021d6d836bea")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
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
    
    let dispatchGroup = DispatchGroup()
    var check = false
    
    
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
        } else if Password.text != C_Password.text {
            let alert = UIAlertController(title: "Sorry", message:"Your password and confirmed password are not matched.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
        }else{
            
            self.check = false
            checkExist()
            
            
            dispatchGroup.notify(queue: .main){
                if(self.check){
                    let alert = UIAlertController(title: "Sorry", message:"Your username has already been registered. Please change another username.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
                    self.present(alert, animated: true){}
                }else{
                    self.postToDB()
                }
            }
        }
    }
    
    func postToDB(){
        let userid:String = Username.text!
        let passwd:String = Password.text!
        let question:String = SecurityQ.text!
        let answer:String = Answer.text!
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToCreate:Account = Account()
        
        itemToCreate._userId = userid
        itemToCreate._password = passwd
        itemToCreate._question = question
        itemToCreate._answer = answer
        
        print("userid: \(itemToCreate._userId!), password: \(itemToCreate._password!), question: \(itemToCreate._question!), answer: \(itemToCreate._answer!)")
        objectMapper.save(itemToCreate, completionHandler:{(error: Error?) -> Void in
            if let error = error{
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("User data updated or saved initially")
            
        })
        
    }
    
    func checkExistAndPost(){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        let userid:String = Username.text!
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": userid,
        ]
        
        var check = true
        objectMapper.load(Account.self, hashKey: userid, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let resultBook = task.result as? Account {
                print("result \(String(describing: resultBook._userId))")
                let alert = UIAlertController(title: "Sorry", message:"Your username has already been registered. Please Change another one. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
                self.present(alert, animated: true){}
                check = false
            }else{
                print("did not find the match")
                self.changeToMain()
            }
            return nil
        })

        
        print("result check \(check)")

    }

    
    func changeToMain(){
        let mainStoryboard = UIStoryboard(name: "Storyboard", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "home_page") as UIViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    func checkExist(){
        dispatchGroup.enter()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        let userid:String = Username.text!
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
                            print("it was 0")
                        }else{
                            self.check = true
                            print("we already have that user")
                        }
                    }
                    self.dispatchGroup.leave()
                }
        }
        )
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
