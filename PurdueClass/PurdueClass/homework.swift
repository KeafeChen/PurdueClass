//
//  homework.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/3/22.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import EventKit
import UIKit

protocol cellDelagateP: class {
    func didPressButton(_ sender: UIButton)
}

class HWcell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    weak var cellDelegate: cellDelagateP?
    @IBOutlet weak var HWdate: UILabel!
    @IBOutlet weak var HWdescription: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBAction func buttonPressed(_ sender: UIButton) {
        let button = sender
        
        cellDelegate?.didPressButton(button)
    }

    
    // @IBAction func HWSwitch(_ sender: Any)
    
    func configureCell(cell: HWcell, hwcelldata: HWData){
        HWdescription.text=hwcelldata.description
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "MMMM-dd HH:mm"
        HWdate.text=dateFormattor.string(from: hwcelldata.date)
        if(hwcelldata.todoCheck == false){
            cell.btn.setTitle("DONE", for: .normal)
        }
        if(hwcelldata.todoCheck == true){
            cell.btn.setTitle("TODO", for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
class homework: UIViewController, UITableViewDelegate, UITableViewDataSource , cellDelagateP{
    //class HeadlineTableViewCell: UITableViewCell {
    //}
    
    //  struct HW{
    
    //    var hwDescription: String
    //  var dueDate: String
    // }
    
    func didPressButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            let index = indexPath.row

            if(current){
                let todoo = data1[index].todoCheck
                if(todoo){
                    data1[index].todoCheck = false
                    sender.setTitle("DONE", for: .normal)

                }else{
                    data1[index].todoCheck = true
                    sender.setTitle("TODO", for: .normal)

                }
            }else{
                let todoo = data2[index].todoCheck
                if(todoo){
                    data1[index].todoCheck = false
                    sender.setTitle("DONE", for: .normal)

                }else{
                    data1[index].todoCheck = true
                    sender.setTitle("TODO", for: .normal)

                }
            }
            
        }
    }
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
   /* @IBAction func todoAction(_ sender: Any) {
        let cell = (sender as AnyObject).superview?.superview?.superview as! UITableViewCell
        var indexPath = tableView.indexPath(for: cell)
        if(current){
            let index = (indexPath?.row)!
            var todoo = data1[index].todoCheck
            if(todoo){
                todoo = false
            }else{
                todoo = true
            }
        }else{
            let index = (indexPath?.row)!
            var todoo = data2[index].todoCheck
            if(todoo){
                todoo = false
            }else{
                todoo = true
            }
        }
    }*/

    
    let eventStore = EKEventStore()
    private  let notificationPublisher = NotificationPublisher()
    
    @IBAction func ExportEvent(_ sender: Any) {
        if(data1.count == 0){
            let alert = UIAlertController(title: "Sorry", message:"You cannot export nothing to your calendar. Please add homework first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
            self.present(alert, animated: true){}
            return
        }
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
    var newDate = Date()
//    var newMonth = Int()
//    var newDay = Int()
//    var newHour = Int()
//    var newMin = Int()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    // var data = [HW]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
        if newDescription != ""{
            addNewIfSome()
        }
        
        sortDue()
        

        
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
                    
                  //  let dateComponent = DateComponents(calendar: Calendar.current, era: 1, year: 2019, month: thisdata.month, day: thisdata.day, hour: 23, minute: 0 )
                    
                    let clddate = thisdata.date//thisCalendar.date(from: dateComponent)!
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
                    event.endDate = clddate
                    event.startDate = clddate.addingTimeInterval(-60*59)

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
        /*var tokens = newDate.split(separator: " ")
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
            newDay = Int(tokens[1])!*/
        
            var present = Date()
        if(newDate<present && current == true){
            change((Any).self)
        }
        if(newDate>present && current == false){
            change((Any).self)
        }
        
            if current == true{
                data1.append(HWData(description: newDescription, date: newDate, todoCheck: true//,HWswitch: false
                ))
            }
            else{
                data2.append(HWData(description: newDescription, date: newDate, todoCheck: true//,HWswitch: false
                ))
            }
        
        
    }
    
    func sortDue(){
        if(current == true){
            data1.sort{
                ($0.date) <
                    ($1.date)
            }
        }else{
            data2.sort{
                ($0.date) <
                    ($1.date)
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
            cell.cellDelegate = self

            //           DispatchQueue.main.async {
            if(current == true){
                cell.configureCell(cell: cell, hwcelldata: data1[indexPath.row])
            }else{
                cell.configureCell(cell: cell, hwcelldata: data2[indexPath.row])
            }
            //         self.dispatchGroup.leave()
            
            //   }
            cell.btn.tag = indexPath.row
            return cell
        }
        
        return UITableViewCell()
    }
    
    // delete cell
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if(current == true){
                data1.remove(at: indexPath.row)
            }else{
                data2.remove(at: indexPath.row)
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
    }
    
    @IBAction func sendNotificationClicked(_ sender: Any) {
        //Temporary notification, need to solve Outlets cannot be connected to repeating content
        
        notificationPublisher.sendNotification(title: "HW Added To Reminder", subtitle: "Title: Shell", body: "Due Date: March 12", badge: 1, delayInterval: nil)
        
    }

}
