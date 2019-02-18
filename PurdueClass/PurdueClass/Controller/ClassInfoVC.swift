//
//  ClassInformation.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

//TODO: delete

import UIKit
import Moya
import AWSCore
import AWSAuthCore
import AWSDynamoDB
import AWSMobileClient
import AWSCognito

var user_semester:String!
var user_department:String!
var user_course:String!
var user_professor:String!
var user_title:String!

class ClassInfoVC: UIViewController {
    
    var categoryList: [String]!
    
    @IBOutlet var categoryButtons: [UIButton]!
    
    @IBOutlet weak var SemesterText: UIButton!
    @IBOutlet weak var DepartmentText: UIButton!
    @IBOutlet weak var CourseText: UIButton!
    @IBOutlet weak var ProfessorText: UIButton!
    @IBOutlet weak var TitleText: UIButton!
    
    @IBOutlet var SemesterLabel: UILabel!
    @IBOutlet var DepartmentLabel: UILabel!
    @IBOutlet var CourseLabel: UILabel!
    @IBOutlet var ProfessorLabel: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    
    @IBOutlet var stackview1: UIStackView!
    @IBOutlet var stackview2: UIStackView!
    @IBOutlet var stackview3: UIStackView!
    
    var textToUpdate: String!
    var categryToUpdate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:b3912726-6290-4b03-9457-021d6d836bea")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        switch categryToUpdate {
        case "searchForDepartment":
            user_department = textToUpdate
        case "searchForCourse":
            user_course = textToUpdate
        case "searchForProfessor":
            user_professor = textToUpdate
        case "searchForSemester":
            user_semester = textToUpdate
        case "searchForTitle":
            user_title = textToUpdate
        default:
            break
        }
        
        SemesterText.setTitle(user_semester, for: .normal)
        DepartmentText.setTitle(user_department, for: .normal)
        CourseText.setTitle(user_course, for: .normal)
        ProfessorText.setTitle(user_professor, for: .normal)
        TitleText.setTitle(user_title, for: .normal)
        
        
        
        stackview1.arrangedSubviews[0].isHidden = (SemesterText.currentTitle == nil)
        stackview2.arrangedSubviews[0].isHidden = (SemesterText.currentTitle == nil)
        stackview3.arrangedSubviews[0].isHidden = (SemesterText.currentTitle == nil)
        
        stackview1.arrangedSubviews[1].isHidden = (DepartmentText.currentTitle == nil)
        stackview2.arrangedSubviews[1].isHidden = (DepartmentText.currentTitle == nil)
        stackview3.arrangedSubviews[1].isHidden = (DepartmentText.currentTitle == nil)
        
        
        stackview1.arrangedSubviews[2].isHidden = (CourseText.currentTitle == nil)
        stackview2.arrangedSubviews[2].isHidden = (CourseText.currentTitle == nil)
        stackview3.arrangedSubviews[2].isHidden = (CourseText.currentTitle == nil)
        
        stackview1.arrangedSubviews[3].isHidden = (TitleText.currentTitle == nil)
        stackview2.arrangedSubviews[3].isHidden = (TitleText.currentTitle == nil)
        stackview3.arrangedSubviews[3].isHidden = (TitleText.currentTitle == nil)
        
        stackview1.arrangedSubviews[4].isHidden = (ProfessorText.currentTitle == nil)
        stackview2.arrangedSubviews[4].isHidden = (ProfessorText.currentTitle == nil)
        stackview3.arrangedSubviews[4].isHidden = (ProfessorText.currentTitle == nil)
    }
    
    
    @IBAction func handleSelection(_ sender: Any) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func categoryTapped(_ sender: Any) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    @IBAction func SemesterTextSegue(_ sender: Any) {
        performSegue(withIdentifier: "searchForSemester", sender: self)
    }
    
    
    @IBAction func DepartmentTextSegue(_ sender: Any) {
        performSegue(withIdentifier: "searchForDepartment", sender: self)
    }
    
    
    @IBAction func CourseTextSegue(_ sender: Any) {
        performSegue(withIdentifier: "searchForCourse", sender: self)
    }
    
    
    @IBAction func ProfessorTextSegue(_ sender: Any) {
        performSegue(withIdentifier: "searchForProfessor", sender: self)
    }
    
    @IBAction func TitleTextSegue(_ sender: Any) {
        performSegue(withIdentifier: "searchForTitle", sender: self)
    }
    
    
    
    @IBAction func cancel0(_ sender: Any) {
        SemesterText.setTitle(nil, for: .normal)
        user_semester = nil
        stackview1.arrangedSubviews[0].isHidden = true
        stackview2.arrangedSubviews[0].isHidden = true
        stackview3.arrangedSubviews[0].isHidden = true
    }
    
    
    @IBAction func cancel1(_ sender: Any) {
        DepartmentText.setTitle(nil, for: .normal)
        user_department = nil
        stackview1.arrangedSubviews[1].isHidden = true
        stackview2.arrangedSubviews[1].isHidden = true
        stackview3.arrangedSubviews[1].isHidden = true
    }
    
    
    @IBAction func cancel2(_ sender: Any) {
        CourseText.setTitle(nil, for: .normal)
        user_course = nil
        stackview1.arrangedSubviews[2].isHidden = true
        stackview2.arrangedSubviews[2].isHidden = true
        stackview3.arrangedSubviews[2].isHidden = true
    }
    
    @IBAction func cancel3(_ sender: Any) {
        TitleText.setTitle(nil, for: .normal)
        user_title = nil
        stackview1.arrangedSubviews[3].isHidden = true
        stackview2.arrangedSubviews[3].isHidden = true
        stackview3.arrangedSubviews[3].isHidden = true
    }
    
    @IBAction func cancel4(_ sender: Any) {
        ProfessorText.setTitle(nil, for: .normal)
        user_professor = nil
        stackview1.arrangedSubviews[4].isHidden = true
        stackview2.arrangedSubviews[4].isHidden = true
        stackview3.arrangedSubviews[4].isHidden = true
    }
    
    
    @IBAction func prepareSearch(_ sender: Any) {
        performSegue(withIdentifier: "toSearchResult", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.searchKey = segue.identifier
        }
        
        if let searchResultVC = segue.destination as? SearchResultVC{
            searchResultVC.semester = user_semester
            searchResultVC.department = user_department
            searchResultVC.course = user_course
            searchResultVC.course_title = user_title
            searchResultVC.professor = user_professor
        }
    }
    
    
    func postToDB(){
        let userid:String = "JD"
        let passwd:String = "1"
        let question:String = "1"
        let answer:String = "1"
        
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
    
}

