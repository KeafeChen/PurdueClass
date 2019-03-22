//
//  homework.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/3/22.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import EventKit
import UIKit


class homework: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //class HeadlineTableViewCell: UITableViewCell {
    //}
    
    //  struct HW{
    
    //    var hwDescription: String
    //  var dueDate: String
    // }
    
    let eventStore = EKEventStore()
    
    
    @IBAction func ExportEvent(_ sender: Any) {
        
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
        //insertEvent(store: eventStore)
        //print("inside export event")
    }
    var newDescription = String()
    var newDate = String()
    var newMonth = Int()
    var newDay = Int()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    // var data = [HW]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
        if newDescription != ""{
            addNewIfSome()
        }
        
        self.sortDue()
        

        
        /*    data = [
         HW.init(hwDescription: "hello", dueDate:"world"),
         HW.init(hwDescription: "test", dueDate:"world"),
         HW.init(hwDescription: "hello", dueDate:"world"),
         HW.init(hwDescription: "hello", dueDate:"world")]*/
        //self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        //  self.tableView.register(CustomCell.self, forCellReuseIdentifier: "hwcell")
    }
    
    func insertEvent(store: EKEventStore) {
        
        print("inside insertevent")
        
        // 1
        let calendars = store.calendars(for: .event)
        for calendar in calendars {
            // 2
            if calendar.title == "Calendar" {
                //print("inside calendar")
                //print(data1.count)
                for thisdata in data1{
                    //                    var yeartoadd = 2019;
                    //                    var daytoadd = thisdata.day;
                    //                    var monthtoadd = thisdata.month;
                    let thisCalendar = Calendar.current
                    
                    let dateComponent = DateComponents(calendar: Calendar.current, era: 1, year: 2019, month: thisdata.month, day: thisdata.day, hour: 23)
                    
                    let clddate = thisCalendar.date(from: dateComponent)!
                    // Calendar.current.date(byAdding: dateComponent, to: clddate)
                    
                    // 3
                    //let startDate = Date()
                    // 2 hours
                    // let endDate = dateComponent.addingTimeInterval(2 * 60 * 60)
                    
                    // 4
                    let event = EKEvent(eventStore: store)
                    event.calendar = calendar
                    
                    event.title = thisdata.description
                    print("test description")
                    //print(data1.description)
                    event.startDate = clddate
                    event.endDate = clddate.addingTimeInterval(60*59)
                    
                    // 5
                    do {
                        try store.save(event, span: .thisEvent)
                    }
                    catch {
                        print("Error saving event in calendar")             }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //var data: [String] = []
    //let hwDescription = ["myShell", "quiz1", "server chat" ]
    //let dueDate = ["Jan 07 11:59","Jan 20 11:59","Jan 11 11:59"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(current == true){
            return data1.count
        }
        return data2.count
        
        
    }
    @IBOutlet weak var changeButton: UIButton!
    
    @IBAction func change(_ sender: Any) {
        if(current == true){
            current = false
            tableView.reloadData()
            changeButton.setTitle("My past due", for: .normal)
        }else{
            current = true
            tableView.reloadData()
            changeButton.setTitle("My current due", for: .normal)
        }
    }
    @IBAction func addHW(_ sender: Any) {
        
    }
    func addNewIfSome(){
        var tokens = newDate.split(separator: " ")
        if tokens.count > 1{
            switch tokens[0]{
            case "January": newMonth = 1;
            case "February": newMonth = 2;
            case "March": newMonth = 3;
            case "April": newMonth = 4;
            case "May": newMonth = 5;
            case "June": newMonth = 6;
            case "July": newMonth = 7;
            case "August": newMonth = 8;
            case "September": newMonth = 9;
            case "October": newMonth = 10;
            case "November": newMonth = 11;
            case "December": newMonth = 12;
                
            default:
                newMonth = 0;
            }
            newDay = Int(tokens[1])!
            if current == true{
                data1.append(HWData(description: newDescription, date: newDate, month: newMonth, day: newDay//,HWswitch: false
                ))
            }
            else{
                data2.append(HWData(description: newDescription, date: newDate, month: newMonth, day: newDay//,HWswitch: false
                ))
            }
        }
        
        
    }
    
    func sortDue(){
        if(current == true){
            data1.sort{
                ($0.month, $0.day) <
                    ($1.month, $1.day)
            }
        }else{
            data2.sort{
                ($0.month, $0.day) <
                    ($1.month, $1.day)
            }
        }
        
        
    }
    
    
    /*
     func quicksort<T: Comparable>(_ a: [T]) -> [T] {
     guard a.count > 1 else { return a }
     
     let pivot = a[a.count/2]
     let less = a.filter { $0 < pivot }
     let equal = a.filter { $0 == pivot }
     let greater = a.filter { $0 > pivot }
     
     return quicksort(less) + equal + quicksort(greater)
     }
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell=tableView.dequeueReusableCell(withIdentifier: "hwcell", for: indexPath) as? HWcell{
            
            //           DispatchQueue.main.async {
            if(current == true){
                cell.configureCell(hwcelldata: data1[indexPath.row])
            }else{
                cell.configureCell(hwcelldata: data2[indexPath.row])
            }
            //         self.dispatchGroup.leave()
            
            //   }
            return cell
        }
        
        return UITableViewCell()
    }
}
