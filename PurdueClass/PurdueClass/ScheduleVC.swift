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
    var user:String? = nil
    var weekday:Int = NSCalendar.current.component(.weekday, from: Date());
    
    
    @IBOutlet weak var export_button: UIButton!
    
    let defaults = UserDefaults.standard
    
    lazy var popUpWindow: PopUpWindow = {
        let view = PopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        user = (UserDefaults.standard.string(forKey: "username")!)
        export_button.addTarget(self, action: #selector(handleShowPopUp), for: .touchUpInside)
        export_button.layer.cornerRadius = 5
        
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        
        visualEffectView.alpha = 0
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
        print("current user name is \(user)")

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
            if flag {
                eventList.append(newEvent)
                var temp_array : Array<String> = Array()
                temp_array.append(semester_value)
                temp_array.append(course_value)
                temp_array.append(professor_value)
                temp_array.append(department_value)
                temp_array.append(weekday_value)
                temp_array.append(start_value)
                temp_array.append(end_value)
                temp_array.append(detail_value)
                local_store.append(temp_array)
                defaults.set(local_store, forKey:"schedule")
            }
        }
        
        //delete
        if eventToDelete != nil {
            print("haha")
            print(eventToDelete!.course)
            for indexi in 0...(eventList.count-1){
                let xxx = eventList[indexi]
                if xxx.course == eventToDelete!.course && xxx.semester == eventToDelete!.semester {
                    eventList.remove(at: indexi)
                    local_store.remove(at: indexi)
                    defaults.set(local_store, forKey:"schedule")
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
        if let searchResultVC = segue.destination as? HomePage{
            searchResultVC.semester_value = semester_value
            searchResultVC.department_value = department_value
            searchResultVC.course_value = course_value
            searchResultVC.professor_value = professor_value
            searchResultVC.detail_value = detail_value
            searchResultVC.weekday_value = weekday_value
            searchResultVC.start_value = start_value
            searchResultVC.end_value = end_value
        }
    }
    
    @IBAction func save_screenshot(_ sender: Any) {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
    }
    
    @objc func handleShowPopUp() {
        
        view.addSubview(popUpWindow)
        popUpWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        popUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        popUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpWindow.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.popUpWindow.alpha = 1
            self.popUpWindow.transform = CGAffineTransform.identity
        }
        
        print("Show pop up window..")
    }
    
}




extension ScheduleVC: PopUpDelgate {
    func handleDismissalIOS() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpWindow.removeFromSuperview()
            print("remove pop up ios")
        }
    }
    
    func handleDismissalGoogle() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpWindow.removeFromSuperview()
            print("remove pop up google")
        }
    }
}
