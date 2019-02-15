//
//  ClassInformation.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import Moya


class ClassInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    /*
        course struct
        sxm
    */
    struct courseInfo {
        var courseNum : String?
        var title : String?
        var department : String?
        var prof : String?
        var semester : String?
    }
    /*
    var courseInfo = Array<(courseNum: String, title: String, department: String, prof: String, semester: String)>()

    
    var datumOne = ("CS 000", "O-OP", "CS", "Dunsmore", "sp 19")
    courseInfo += datumOne
    */
    
    // index
    var myIndex = 0

    // whole data sheet
    let data = [
    courseInfo(courseNum: "CS 180", title: "O-OP", department: "CS", prof: "Dunsmore", semester: "sp 19"),
    courseInfo(courseNum: "CS 240", title: "Programming in C", department: "CS", prof: "Jeff", semester: "sp 18")
    ]
    
    
    /*
        There is a bug that when result is updated, cells in table view cannot be displayed
 
    */
    
    var result = [courseInfo?]()
    
    // let result = []
 
    //var courseList: [courseInfo] = []
    

    //let cs180: courseInfo = courseInfo(courseNum: "CS 180", title: "O-OP", department: "CS", prof: "Dunsmore", semester: "sp 19");
    //let cs240: courseInfo  = courseInfo(courseNum: "CS 240", title: "Programming in C", department: "CS", prof: "Jeff", semester: "sp 18");
    //let engl106: courseInfo  = courseInfo(courseNum: "ENGL 106", title: "First Year Composition", department: "ENGL", prof: "Wang", semester: "fall 18");
    //let list=["CS 180","CS 240","ENGL 106"]
    //let list = courseList[].courseNum
    
    
    /*
        table view number of rows
        sxm
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return(courseList.count)
        //courseList.append(cs180)
        //courseList.append(cs240)
        //courseList.append(engl106)


        //print(courseList.count)
        
        
        // BUG HERE
        return data.count
    }
    
    //var list = ["cs180","cs240","engl106"]
    
    /*
        this is used to setup the result list
        sxm
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        _ = result


        print("1111111111")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //print("TESTtTTTTTTTTTT")
        
        //print(result[0]?.courseNum)
        cell.textLabel?.text = self.result[indexPath.row]?.courseNum
        //print("test label")
        //print(courseList[indexPath.row].courseNum ?? "faiufdhai")
        return(cell)
    }
    

    

    var categoryList: [String]!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var courseText: UITextField!
    
    var titleToDisplay: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseText.text = titleToDisplay ?? "Not Selected"
        
        

        // need to update semester here
        // semesterTextField.text = semesterFieldContent
        
    }
    
    enum Categories: String{
        case department = "Department"
        case course = "Course"
        case professor = "Professor"
        case semester = "Semester"
    }
    
    @IBAction func categoryTaped(_ sender: UIButton) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
        
        guard let title = sender.currentTitle, let category = Categories(rawValue: title) else{
            return
        }
       
        switch category {
        case .department:
            print("Department")
        case .course:
            print("Course")
        case .professor:
            print("Professor")
        case .semester:
            print("Semester")
        }
    }
    

    @IBAction func handleSelection(_ sender: UIButton) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /*
     table view
     sxm
     */
    @IBOutlet weak var tableView: UITableView!
    /*
     search button action
     sxm
    */
    @IBAction func searchButton(_ sender: UIButton) {
        // TODO: filter the results
        
        // result data sheet
        if ((semesterTextField?.text) != nil){
            print("haha?????")
            for classifoo in data{
                if(semesterTextField.text == classifoo.semester){
                    result.append(classifoo)
                    print("yeah!!!!!!!")
                }
            }
        }

        
        tableView.isHidden = false

    }
    
    /*
     this is used to connect the result rows to result page
     sxm
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        myIndex = indexPath.row
        //print("check 1")
        //print(myIndex)
        performSegue(withIdentifier: "segueToResult", sender: self)
    }
    
   // @IBOutlet weak var tableViewOutlet: UITableView!{
   //     willSet{
   //         otherClass.disableAccessTo(handle: newValue)
   //     }
   // }
    /*
    following prepares to set result page's texts
     sxm
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // if statement and the is keyword you check whether the segue destination is of class TertiaryViewController. You need to identify if this is the segue you want to
        if segue.destination is SearchResultVC
        {
            // cast segue.destination to TertiaryViewController, so you can use the username property. The destination property on segue has type UIViewController, so you’ll need to cast it to get to the username property.
            
            
            // TODO replace data with results
            let vc = segue.destination as? SearchResultVC
            //print("check 2")
            //print(myIndex)
            // set the username property, just like you did in the previous example.
            vc?.courseNumber = result[myIndex]?.courseNum ?? "Course Number: nil"
            vc?.courseTitle = result[myIndex]?.title ?? "Title: nil"
            vc?.courseProf = result[myIndex]?.prof ?? "Professor: nil"
            vc?.courseSemester = result[myIndex]?.semester ?? "Semester: nil"
            
            // we need to put data in textField and table view to result VC
            // TODO: need to handle nil condition here
            // TODO: need to deal with all textfields
            /*
             vc?.semesterText = semesterTextField.text ?? "nil"
            print("check 1")
            print(semesterTextField.text ?? "nil")
             */
        }
    }
    // semester text field
    @IBOutlet weak var semesterTextField: UITextField!
    var semesterFieldContent: String = ""
    // department text field
    @IBOutlet weak var departmentTextField: UITextField!
    // professor text field
    @IBOutlet weak var professorTextField: UITextField!
    
    @IBAction func semesterAction(_ sender: Any) {
        
        
    }
    
    
    
}
