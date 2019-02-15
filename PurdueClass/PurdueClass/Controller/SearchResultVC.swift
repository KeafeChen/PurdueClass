//
//  SearchResultVC.swift
//  PurdueClass
//
//  Created by H. on 2/10/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {
    

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var courseNumber:String = ""
    var courseTitle:String = ""
    var courseDepartment:String = ""
    var courseProf:String = ""
    var courseSemester:String = ""

    @IBOutlet weak var courseNumberLabel:UILabel?
    @IBOutlet weak var courseTitleLabel:UILabel?
    @IBOutlet weak var courseProfLabel:UILabel?
    @IBOutlet weak var courseSemesterLabel:UILabel?
    
    /*
        get info from other VCs
        sxm
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        courseNumberLabel?.text = courseNumber
        courseTitleLabel?.text = courseTitle
        courseProfLabel?.text = courseProf
        courseSemesterLabel?.text = courseSemester
        
        //var semesTextField = ClassInfoVC.
    }
    
    /*
        make description height adjustable
        sxm
    */
    func heightAdjustDescription(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))

        label.sizeToFit()
        return label.frame.height
    }
    
    
    /*
     used to retain info in textfield and table view back to classInfo VC
     not necessary (?)
     sxm
    */
    /*
    var semesterText:String = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ClassInfoVC{
            let vc = segue.destination as? ClassInfoVC
            print("check 2")
            print(vc?.semesterFieldContent ?? "nil")
            vc?.semesterFieldContent = semesterText
        }
    }
 */
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
