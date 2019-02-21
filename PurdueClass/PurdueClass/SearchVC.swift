//
//  SearchVC.swift
//  PurdueClass
//
//  Created by H. on 2/10/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let sourcedata = Data()
    var data: [String] = []
    var fetch = false
    
    var titleToPass: String!
    var searchKey:String!
    
    var searchItem:[String] = []
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        switch searchKey {
        case "searchForDepartment":
            data = sourcedata.department
        case "searchForCourse":
            data = sourcedata.course
        case "searchForTitle":
            data = sourcedata.title
        case "searchForProfessor":
            data = sourcedata.professor
        case "searchForSemester":
            data = sourcedata.semester
        default:
            data = []
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searching = true
        searchItem = data.filter({$0.prefix(searchText.count) == searchText})
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchItem.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseCell {
            if searching {
                cell.configureCell(title: searchItem[indexPath.row])
            }
            else {
                cell.configureCell(title: data[indexPath.row])
            }
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetch{
                beginFetch()
            }
        }
    }
    
    func beginFetch() {
        fetch = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.fetch = false
            self.tableView.reloadData()
            print(self.searching)
        })
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let classInfoVC = segue.destination as? ClassInfoVC {
            classInfoVC.textToUpdate = titleToPass
            classInfoVC.categryToUpdate = searchKey
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
