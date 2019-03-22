//
//  HomePage.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//
import Foundation
import FSCalendar
import UIKit

class HomePage: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
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
    var weekday:Int = NSCalendar.current.component(.weekday, from: Date());


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
        self.view.addBackground()
        
        // Do any additional setup after loading the view.
        if course_value != "" {
            print("is not \n\n")
            for xxx in eventList {
                print(xxx)
            }
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
        performSegue(withIdentifier: "toSchedule", sender: self)
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
