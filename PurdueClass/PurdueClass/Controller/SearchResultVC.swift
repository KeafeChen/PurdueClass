//
//  SearchResultVC.swift
//  PurdueClass
//
//  Created by H. on 2/10/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import AWSDynamoDB

//typealias ResponseCompletion = ([AWSDynamoDBObjectModel & AWSDynamoDBModeling]) -> ()

class SearchResultVC: UIViewController {
    let dispatchGroup = DispatchGroup()
    
    var semester: String?
    var department: String?
    var course: String?
    var course_title:String?
    var professor:String?
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var course_name: UITextView!
    @IBOutlet weak var semester_name: UITextView!
    @IBOutlet weak var department_name: UITextView!
    @IBOutlet weak var professor_name: UITextView!
    @IBOutlet weak var description_name: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanTest{ (scanArray) in
            for scanItem in scanArray{
                if let item = scanItem as? BackendCourseInfo {
                    print(item)
                    self.course_name.text = item.course
                    self.semester_name.text = item.semester
                    self.department_name.text = item.department
                    self.professor_name.text = item.professor
                    self.description_name.text = item.detail
                }
            }
        }
        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func scanTest(completion: @escaping ResponseCompletion){
        
        dispatchGroup.enter()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()


        var localDictionary: [String: Any] = [:]
        var localFilterExpression: String? = nil
       
        
        if self.course == nil {
            localFilterExpression = "attribute_exists(course) "
        }
        else {
            localFilterExpression = "course = :course "
            localDictionary.updateValue(self.course!, forKey: ":course")
        }
        
        if self.department == nil{
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
            localDictionary.updateValue(self.department!, forKey: ":department")
        }
        
        if self.semester == nil{
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
            localDictionary.updateValue(self.semester!, forKey: ":semester")
        }
        
        if self.course_title == nil{
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
            localDictionary.updateValue(self.course_title!, forKey: ":title")
        }
        
        if self.professor == nil{
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
            localDictionary.updateValue(self.professor!, forKey: ":professor")
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
                completion(scanArray)
            }
            self.dispatchGroup.leave()
            }
        })
    }
    
}
