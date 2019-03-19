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
    
    @IBOutlet weak var tableView: UITableView!
    
    let data = HWdataset()
    
   // var data = [HW]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
        
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = self.tableView.dequeueReusableCell(withIdentifier: "hwcell")as! CustomCell
       // cell.hwDescription = data[indexPath.row].hwDescription
        //cell.dueDate = data[indexPath.row].dueDate

        
        
        //let text = self.hwDescription[indexPath.row]
        //cell.textLabel?.text = hwDescription[indexPath.row]
        
        if let cell=tableView.dequeueReusableCell(withIdentifier: "hwcell", for: indexPath) as? HWcell{
            cell.configureCell(hwcelldata: data.hwdatasets[indexPath.row])
            return cell
            
        }
        return UITableViewCell()
    }
}
