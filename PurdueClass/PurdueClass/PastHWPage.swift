//
//  HWPage.swift
//  PurdueClass
//
//  Created by Sun on 3/2/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit






class PastHWPage: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //class HeadlineTableViewCell: UITableViewCell {
    //}
    
    //  struct HW{
    
    //    var hwDescription: String
    //  var dueDate: String
    // }
    
    
    @IBOutlet weak var tableView: UITableView!
    let data = HWdataset()
    var data1 = [HWData]()
    var data2 = [HWData]()
    
    // var data = [HW]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        sortDue()
        
        /*    data = [
         HW.init(hwDescription: "hello", dueDate:"world"),
         HW.init(hwDescription: "test", dueDate:"world"),
         HW.init(hwDescription: "hello", dueDate:"world"),
         HW.init(hwDescription: "hello", dueDate:"world")]*/
        //self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        //  self.tableView.register(CustomCell.self, forCellReuseIdentifier: "hwcell")
    }
    
    //  override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
    //  }
    
    //var data: [String] = []
    //let hwDescription = ["myShell", "quiz1", "server chat" ]
    //let dueDate = ["Jan 07 11:59","Jan 20 11:59","Jan 11 11:59"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.hwdatasets.count
        
        
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
        print("see here\n")
        data1 = data.hwdatasets.sorted(by: { $0.month > $1.month})
        data2 = data1
        data2.sort{
            ($0.month, $0.day) >
                ($1.month, $1.day)
        }
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  let cell = self.tableView.dequeueReusableCell(withIdentifier: "hwcell")as! CustomCell
        // cell.hwDescription = data[indexPath.row].hwDescription
        //cell.dueDate = data[indexPath.row].dueDate
        
        
        
        //let text = self.hwDescription[indexPath.row]
        //cell.textLabel?.text = hwDescription[indexPath.row]
        
        if let cell=tableView.dequeueReusableCell(withIdentifier: "pasthwcell", for: indexPath) as? HWcell{
            cell.configureCell(hwcelldata: data2[indexPath.row])
            return cell
            
        }
        return UITableViewCell()
        
    }
    
    
    
    
}
