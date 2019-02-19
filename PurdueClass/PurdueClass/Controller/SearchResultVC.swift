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
    
    @IBOutlet weak var course_name: UITextView!
    @IBOutlet weak var semester_name: UITextView!
    @IBOutlet weak var department_name: UITextView!
    @IBOutlet weak var professor_name: UITextView!
    @IBOutlet weak var description_name: UITextView!
    var course_value:String = ""
    var semester_value:String = ""
    var department_value:String = ""
    var professor_value:String = ""
    var detail_value:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        course_name.text = course_value
        semester_name.text = semester_value
        department_name.text = department_value
        professor_name.text = professor_value
        description_name.text = detail_value
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateMyProfessor(_ sender: Any) {
        let index = self.professor_value.range(of: " ")
        let first_name = self.professor_value.prefix(upTo: index!.lowerBound)
        let last_name = self.professor_value.suffix(from: index!.upperBound)
        UIApplication.shared.openURL(NSURL(string: "https://www.ratemyprofessors.com/search.jsp?query=\(first_name)+\(last_name)")! as URL)
    }
    
    
}
