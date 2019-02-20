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

typealias ResponseCompletion = ([AWSDynamoDBObjectModel & AWSDynamoDBModeling]) -> ()

class ClassInformation: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var classTable: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select the table view")
        myIndex = indexPath.row
        print("\(myIndex)")
        self.performSegue(withIdentifier: "toSearchResultVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    var myIndex = 0
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classes", for: indexPath)
        
        let text = self.data[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }
    
    
    var categoryList: [String]!
    
    var data: [String] = []
    var result: [BackendCourseInfo] = []
    
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
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        self.classTable.allowsSelection = true
        super.viewDidLoad()
        classTable.delegate = self
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
        self.result = []
        self.scanTest{ (scanArray) in
            print("insdie scanTest")
            print(self.result)
        }
        
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.searchKey = segue.identifier
        }
        
        if let searchResultVC = segue.destination as? SearchResultVC{
            searchResultVC.semester_value = self.result[myIndex].semester!
            searchResultVC.department_value = self.result[myIndex].department!
            searchResultVC.course_value = self.result[myIndex].course!
            searchResultVC.professor_value = self.result[myIndex].professor!
            searchResultVC.detail_value = self.result[myIndex].detail!
        }
        
    }
    */
    func scanTest(completion: @escaping ResponseCompletion){
        
        dispatchGroup.enter()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        
        var localDictionary: [String: Any] = [:]
        var localFilterExpression: String? = nil
        
        
        if self.CourseText.currentTitle == nil {
            localFilterExpression = "attribute_exists(course) "
        }
        else {
            localFilterExpression = "course = :course "
            localDictionary.updateValue(self.CourseText.currentTitle!, forKey: ":course")
        }
        
        if self.DepartmentText.currentTitle == nil{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("attribute_exists(department) ")
        }
        else{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("department = :department ")
            localDictionary.updateValue(self.DepartmentText.currentTitle!, forKey: ":department")
        }
        
        if self.SemesterText.currentTitle == nil{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("attribute_exists(semester) ")
        }
        else{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("semester = :semester ")
            localDictionary.updateValue(self.SemesterText.currentTitle!, forKey: ":semester")
        }
        
        if self.TitleText.currentTitle == nil{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("attribute_exists(title) ")
        }
        else{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("title = :title ")
            localDictionary.updateValue(self.TitleText.currentTitle!, forKey: ":title")
        }
        
        if self.ProfessorText.currentTitle == nil{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("attribute_exists(professor) ")
        }
        else{
            if localFilterExpression != nil {
                localFilterExpression?.append("AND ")
            }
            localFilterExpression?.append("professor = :professor ")
            localDictionary.updateValue(self.ProfessorText.currentTitle!, forKey: ":professor")
        }
        
        if localDictionary.count != 0 {
            scanExpression.expressionAttributeValues = localDictionary
        }
        
        scanExpression.filterExpression = localFilterExpression
        print(scanExpression.expressionAttributeValues)
        print(scanExpression.filterExpression)
        
        objectMapper.scan(BackendCourseInfo.self, expression: scanExpression, completionHandler:
            {(task: AWSDynamoDBPaginatedOutput?, error:Error?) -> Void in
                if let error = error {
                    print("The request failed. Error: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    if let scanArray = task?.items {
                        for scanItem in scanArray{
                            if let item = scanItem as? BackendCourseInfo {
                                self.data.append(item.course!)
                                self.result.append(item)
                            }
                        }
                        self.classTable.dataSource = self
                        self.classTable.reloadData()
                        self.dispatchGroup.leave()
                        completion(scanArray)
                    }
                }
        })
    }
    
    
}

