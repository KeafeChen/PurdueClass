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

var data1 = [HWData]()
var data2 = [HWData]()
var current:Bool = true

class HomePage: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var hw1: UIButton!
    
    @IBOutlet weak var hw3: UIButton!
    @IBOutlet weak var hw2: UIButton!
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
    
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        print(data1)
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "MMMM-dd HH:mm"
        if(data1.count == 0){
            hw1.setTitle("None", for: .normal )
            hw2.setTitle("None", for: .normal )
            hw3.setTitle("None", for: .normal )
        }else{
            if(data1.count == 1){
                var _hw1:String = data1[0].description
                _hw1 += "   "
                _hw1 += dateFormattor.string(from: data1[0].date)
                hw1.setTitle(_hw1, for: .normal)
                hw2.setTitle("None", for: .normal )
                hw3.setTitle("None", for: .normal )
            }else if(data1.count == 2){
                var _hw1:String = data1[0].description
                _hw1 += "   "
                _hw1 += dateFormattor.string(from: data1[0].date)
                var _hw2:String = data1[1].description
                _hw2 += "   "
                _hw2 += dateFormattor.string(from: data1[1].date)
                hw1.setTitle(_hw1, for: .normal)
                hw2.setTitle(_hw2, for: .normal )
                hw3.setTitle("None", for: .normal )
            }else if(data1.count >= 3){
                var _hw1:String = data1[0].description
                _hw1 += "   "
                _hw1 += dateFormattor.string(from: data1[0].date)
                var _hw2:String = data1[1].description
                _hw2 += "   "
                _hw2 += dateFormattor.string(from: data1[1].date)
                var _hw3:String = data1[2].description
                _hw3 += "   "
                _hw3 += dateFormattor.string(from: data1[2].date)
                hw1.setTitle(_hw1, for: .normal)
                hw2.setTitle(_hw2, for: .normal )
                hw3.setTitle(_hw3, for: .normal )
            }
        }
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = .week
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        view.addSubview(calendar)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.sendSubviewToBack(calendar)
        self.view.addBackground()
        
        
        var local_store : Array<Array<String>> = Array()
        
        if defaults.value(forKey: "schedule") != nil {
            local_store = defaults.array(forKey: "schedule") as! Array<Array<String>>
        }
        
        if eventList.count != local_store.count {
            for i in local_store{
                var newEvent = Event();
                newEvent.semester = i[0]
                newEvent.course = i[1]
                newEvent.professor = i[2]
                newEvent.department = i[3]
                newEvent.weekday = i[4]
                newEvent.start = i[5]
                newEvent.end = i[6]
                newEvent.detail = i[7]
                eventList.append(newEvent)
            }
        }
        
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
