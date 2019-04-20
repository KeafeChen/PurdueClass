//
//  forgetCurrentPassword.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/3/21.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import AWSCognito
import AWSDynamoDB

class forgetCurrentPassword: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var select: UIButton!
    @IBOutlet weak var selections: UITableView!
    @IBOutlet weak var currentPass: UILabel!
    @IBOutlet weak var GetMyPassword: UIButton!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        GetMyPassword.addButtonDesign()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:b3912726-6290-4b03-9457-021d6d836bea")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        // Do any additional setup after loading the view.
        selections.isHidden = true
    }
    @IBOutlet weak var Answer: UITextField!
    
    let seq = ["What's your father's first name", "What's your mather's first name"]
    
    var question = ""
        
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    let dispatchGroup = DispatchGroup()
    var check = false
    
    @IBAction func getPassword(_ sender: Any) {
        let user:String! = username.text
        let q:String! = question
        let answer:String! = Answer.text
        if(user == nil){
            let alert = UIAlertController(title: "Sorry", message:"Please enter your username.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
            return
        }
        if( q == nil || q == ""){
            let alert = UIAlertController(title: "Sorry", message:"Please select your security question.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
            return
        }
        if(answer == ""){
            let alert = UIAlertController(title: "Sorry", message:"Please enter your answer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
            return
        }
        
        dispatchGroup.enter()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        let userid:String = user
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
                    if(response != nil){
                        print("we got response")
                        if(response?.items.count == 0){
                            print("it was 0")
                        }else{
                            if let res = response?.items{
                                for item in res{
                                    if let itemV = item as? Account{
                                        self.currentPass.text = itemV._password
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

extension forgetCurrentPassword: UITableViewDelegate, UITableViewDataSource {
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
