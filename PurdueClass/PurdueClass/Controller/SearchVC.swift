//
//  SearchVC.swift
//  PurdueClass
//
//  Created by H. on 2/10/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    let data = ["CS252","CS307","CS408","CS252","CS307","CS408","CS252","CS307","CS408","CS252","CS307","CS408","CS252","CS307","CS408","CS252","CS307","CS408"]
    
    var titleToPass: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseCell {
            cell.configureCell(title: data[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleToPass = data[indexPath.row]
        performSegue(withIdentifier: "toClassInfoVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let classInfoVC = segue.destination as? ClassInfoVC {
            classInfoVC.titleToDisplay = titleToPass
        }
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
