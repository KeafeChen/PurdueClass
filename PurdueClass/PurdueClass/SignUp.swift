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
    
    
    @IBOutlet weak var select: UIButton!
    @IBOutlet weak var selections: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        SignButton.addButtonDesign()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:b3912726-6290-4b03-9457-021d6d836bea")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        // Do any additional setup after loading the view.
        selections.isHidden = true
        
        
        
    }
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var C_Password: UITextField!
    @IBOutlet weak var Answer: UITextField!
    
    let seq = ["What's your father's first name", "What's your mather's first name"]
    
    var question = ""
    
    @IBOutlet weak var Information: UILabel!
    
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let dispatchGroup = DispatchGroup()
    var check = false
    
    
    @IBAction func selectquestion(_ sender: Any) {
        if selections.isHidden{
            animate(toogle: true)
        } else {
            animate(toogle: false)
        }
    }

    
    func animate(toogle: Bool){
        if toogle {
            UIView.animate(withDuration: 0.3){
                self.selections.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3){
                self.selections.isHidden = true
            }
        }
    }
    
    
    
    @IBAction func SignUpButton(_ sender: Any) {
        let username:String! = Username.text
        let password:String! = Password.text
        let c_password:String! = C_Password.text
        let answer:String! = Answer.text
        
        if username == "" || password == ""
            || c_password == "" || answer == ""{
            let alert = UIAlertController(title: "Sorry", message:"You have to Enter the username and password First", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
        } else if password.count < 8 {
            let alert = UIAlertController(title: "Sorry", message:"Password must be 8 characters at least", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
        } else if password != c_password {
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
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(userid, forKey: "username")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "home_page") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }
        })
        
        
        print("result check \(check)")
        
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

extension SignUp: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seq.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = seq[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        select.setTitle("\(seq[indexPath.row])", for: .normal)
        self.question = "\(seq[indexPath.row])"
        print(self.question)
        animate(toogle: false)
    }
}
