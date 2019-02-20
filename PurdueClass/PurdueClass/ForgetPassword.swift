//
//  ForgetPassword.swift
//  PurdueClass
//
//  Created by SH on 2/13/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS

class ForgetPassword: UIViewController {

    @IBOutlet weak var ForgetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ForgetButton.layer.cornerRadius = 20
        view.addBackground()    
        // Do any additional setup after loading the view.
    }
    
    let dispatchGroup = DispatchGroup()
    var check = 0
    
    
    @IBOutlet weak var select: UIButton!
    
    @IBOutlet weak var selections: UITableView!
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Answer: UITextField!
    @IBOutlet weak var N_Password: UITextField!
    @IBOutlet weak var C_Password: UITextField!
    
    @IBOutlet weak var Information: UILabel!
    var seq = ["What's your father's first name", "What's your mather's first name"]
    var question = ""
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SelectionButton(_ sender: Any) {
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
    
    @IBAction func ResetPassword(_ sender: Any) {
        let username:String! = Username.text
        let answer:String! = Answer.text
        let password:String! = N_Password.text
        let c_password:String! = C_Password.text
        
        if username == "" || password == ""
            || c_password == "" || answer == ""{
            
            let alert = UIAlertController(title: "Sorry", message:"You have to Enter the username and password First", preferredStyle: .alert)
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
                    let alert = UIAlertController(title: "Sorry", message:"question and the answer does not match", preferredStyle: .alert)
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
        
        let username:String! = Username.text
        let answer:String! = Answer.text
        
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
                            self.check = 0
                        }else{
                            for item in (response?.items)! {
                                if ((item.value(forKey: "_question") != nil) && (item.value(forKey: "_answer") != nil)){
                                    if let q = item.value(forKey: "_question") as? String{
                                        if let a = item.value(forKey: "_answer") as? String{
                                            if (q == self.question && a == answer){
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
    func changePassword(){
        let username:String! = Username.text
        let answer:String! = Answer.text
        let password:String! = N_Password.text
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToDelete:Account = Account()
        
        itemToDelete._userId = username
        itemToDelete._question = question
        itemToDelete._answer = answer
        
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
                UserDefaults.standard.set(username, forKey: "username")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "home_page") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }
        })
        
    }
}

extension ForgetPassword: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seq.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell.textLabel?.text = seq[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        select.setTitle("\(seq[indexPath.row])", for: .normal)
        self.question = "\(seq[indexPath.row])"
        animate(toogle: false)
    }
}
