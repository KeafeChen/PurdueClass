//
//  EventDetailVC.swift
//  
//
//  Created by H. on 3/21/19.
//

import Foundation

class EventDetailVC: UIViewController {
    
    var eventDetail = Event()
    var course_value:String = ""
    var semester_value:String = ""
    var department_value:String = ""
    var professor_value:String = ""
    var detail_value:String = ""
    var weekday_value: String = ""
    var start_value: String = ""
    var end_value : String = ""
    
    
    @IBOutlet weak var course_name: UITextView!
    @IBOutlet weak var semester_name: UITextView!
    @IBOutlet weak var description_name: UITextView!
    @IBOutlet weak var weekday_name: UITextView!
    @IBOutlet weak var professor_name: UITextView!
    @IBOutlet weak var department_name: UITextView!
    @IBOutlet weak var start_name: UITextView!
    @IBOutlet weak var end_name: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if eventDetail != nil {
            course_name.text = eventDetail.course
            semester_name.text = eventDetail.semester
            department_name.text = eventDetail.department
            professor_name.text = eventDetail.professor
            description_name.text = eventDetail.detail
            weekday_name.text = eventDetail.weekday
            start_name.text = eventDetail.start
            end_name.text = eventDetail.end
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteCourse(_ sender: Any) {
        performSegue(withIdentifier: "deleteCourse", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scheduleVC = segue.destination as? ScheduleVC{
            scheduleVC.eventToDelete = eventDetail
        }
    }
}

