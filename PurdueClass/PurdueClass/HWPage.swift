//
//  HWPage.swift
//  PurdueClass
//
//  Created by Sun on 3/2/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit






class HWPage: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //class HeadlineTableViewCell: UITableViewCell {
    //}

  //  struct HW{
        
    //    var hwDescription: String
      //  var dueDate: String
   // }
    var newDescription = String()
    var newDate = String()
    var newMonth = Int()
    var newDay = Int()
    @IBOutlet weak var tableView: UITableView!
    
    private let notificationPublisher = NotificationPublisher()
    let data = HWdataset()
    var data1 = [HWData]()
    var data2 = [HWData]()
    
   // var data = [HW]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        data1=data.hwdatasets
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //var data: [String] = []
    //let hwDescription = ["myShell", "quiz1", "server chat" ]
    //let dueDate = ["Jan 07 11:59","Jan 20 11:59","Jan 11 11:59"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data2.count
        

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
            case "Decemebr": newMonth = 12;
                
            default:
                newMonth = 0;
            }
            newDay = Int(tokens[1])!
            data1.append(HWData(description: newDescription, date: newDate, month: newMonth, day: newDay//,HWswitch: false
            ))
        }
        //print("test new goes here")
        //print(newDescription)
        //print(newDate)
        //print(newMonth)
        //print(newDay)

    }
 
    func sortDue(){
        //for hw in data.hwdatasets{
        //  if hw
        //}
        //        var sortdatelist = [Int]()
        // for i in data.hwdatasets{
        //   sortdatelist.append(i.month*10+i.day)
        // }
        
        //        quicksort(data.hwdatasets)
        //print("see here\n")
        //print(data.hwdatasets.sorted(by: { $0.month < $1.month}))
        //data1 = data.hwdatasets
        //data1.append(somestuff)
        data2 = data1
        data2.sort{
            ($0.month, $0.day) <
                ($1.month, $1.day)
        }
        
        print("test data 22222222")
        print(data2)
//        _ = data1.sort {
//            if $0.month != $1.month {
//                return $0.month < $1.month
//            }
//            else {
//                return $0.day < $1.day
//            }
//
//        }
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
      //  let cell = self.tableView.dequeueReusableCell(withIdentifier: "hwcell")as! CustomCell
       // cell.hwDescription = data[indexPath.row].hwDescription
        //cell.dueDate = data[indexPath.row].dueDate

        
        
        //let text = self.hwDescription[indexPath.row]
        //cell.textLabel?.text = hwDescription[indexPath.row]
        
        // test data2 here
        
        print("test data2")

        if let cell=tableView.dequeueReusableCell(withIdentifier: "hwcell", for: indexPath) as? HWcell{
            print(cell)
 //           DispatchQueue.main.async {
            cell.configureCell(hwcelldata: self.data2[indexPath.row])
   //         self.dispatchGroup.leave()

     //   }
            return cell
        }
        
    
        return UITableViewCell()
        }
    
    
    @IBAction func sendNotificationClicked(_ sender: Any) {
        //Temporary notification, need to solve Outlets cannot be connected to repeating content
        
        notificationPublisher.sendNotification(title: "HW Added To Reminder", subtitle: "Title: Shell", body: "Due Date: March 12", badge: 1, delayInterval: nil)
        
    }
    
}




