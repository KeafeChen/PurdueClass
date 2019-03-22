//
//  ScheduleVC.swift
//  PurdueClass
//
//  Created by H. on 3/21/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import Foundation
import UIKit

var eventList:[Event] = []

var data = [[],[Event()],[Event()],[Event()],[Event()],[Event()],[]]

class ScheduleVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var weekday:Int = NSCalendar.current.component(.weekday, from: Date());
    
    var course_value:String = ""
    var semester_value:String = ""
    var department_value:String = ""
    var professor_value:String = ""
    var detail_value:String = ""
    var weekday_value: String = ""
    var start_value: String = ""
    var end_value : String = ""
    var eventTodisplay = Event()
    var eventToDelete : Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = .week
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        view.addSubview(calendar)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.sendSubviewToBack(calendar)
        
        //
        if course_value != "" {
            var newEvent = Event();
            newEvent.semester = semester_value
            newEvent.course = course_value
            newEvent.professor = professor_value
            newEvent.department = department_value
            newEvent.weekday = weekday_value
            newEvent.start = start_value
            newEvent.end = end_value
            newEvent.detail = detail_value
            
            var flag = true
            for xxx in eventList {
                if xxx.course == newEvent.course && xxx.semester == newEvent.semester {flag = false}
            }
            if flag { eventList.append(newEvent)}
        }
        
        //delete
        if eventToDelete != nil {
            print("haha")
            print(eventToDelete!.course)
            for indexi in 0...(eventList.count-1){
                let xxx = eventList[indexi]
                if xxx.course == eventToDelete!.course && xxx.semester == eventToDelete!.semester {
                    eventList.remove(at: indexi)
                    break;
                }
            }
            eventToDelete = nil
        }
        
        //
        data.removeAll();
        data = [[],[],[],[],[],[],[]]
        
        for xxx in eventList {
            if let day = xxx.weekday {
                if day.contains("M"){ data[1].append(xxx)}
                if day.contains("T"){ data[2].append(xxx)}
                if day.contains("W"){ data[3].append(xxx)}
                if day.contains("R"){ data[4].append(xxx)}
                if day.contains("F"){ data[5].append(xxx)}
            }
        }
        
        //TODO: sort data based on start time
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)      //date selected
        weekday = NSCalendar.current.component(.weekday, from: date)
        print(weekday)  //weekdate selected   1-Sunday,  7-Saturday
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[weekday-1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let stringToPass : String
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventCell {
            if let start = data[weekday-1][indexPath.row].start {
                let end = data[weekday-1][indexPath.row].end ?? ""
                let course = data[weekday-1][indexPath.row].course ?? ""
                stringToPass = start+"-"+end+" "+course
                cell.configureCell(title: stringToPass)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventTodisplay = data[weekday-1][indexPath.row]
        performSegue(withIdentifier: "displayEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventDetailVC = segue.destination as? EventDetailVC {
            eventDetailVC.eventDetail = eventTodisplay
        }
    }
    
}

