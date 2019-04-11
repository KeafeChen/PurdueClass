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
    var user:String? = nil

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
    @IBOutlet weak var weekday_name: UITextView!
    @IBOutlet weak var start_name: UITextView!
    @IBOutlet weak var end_name: UITextView!
    
    var course_value:String = ""
    var semester_value:String = ""
    var department_value:String = ""
    var professor_value:String = ""
    var detail_value:String = ""
    var weekday_value: String = ""
    var start_value: String = ""
    var end_value : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = (UserDefaults.standard.string(forKey: "username")!)
        self.view.addBackground()
        addtomyclass.addButtonDesign()
        ratemyprofessor.addButtonDesign()
        course_name.text = course_value
        semester_name.text = semester_value
        department_name.text = department_value
        professor_name.text = professor_value
        description_name.text = detail_value
        weekday_name.text = weekday_value
        start_name.text = start_value
        end_name.text = end_value
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var addtomyclass: UIButton!
    @IBOutlet weak var ratemyprofessor: UIButton!
    @IBAction func rateMyProfessor(_ sender: Any) {
        let index = self.professor_value.range(of: " ")
        let first_name = self.professor_value.prefix(upTo: index!.lowerBound)
        let last_name = self.professor_value.suffix(from: index!.upperBound)
        UIApplication.shared.openURL(NSURL(string: "https://www.ratemyprofessors.com/search.jsp?query=\(first_name)+\(last_name)")! as URL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scheduleVC = segue.destination as? ScheduleVC{
            scheduleVC.semester_value = semester_value
            scheduleVC.department_value = department_value
            scheduleVC.course_value = course_value
            scheduleVC.professor_value = professor_value
            scheduleVC.detail_value = detail_value
            scheduleVC.weekday_value = weekday_value
            scheduleVC.start_value = start_value
            scheduleVC.end_value = end_value
        }
    }
}
