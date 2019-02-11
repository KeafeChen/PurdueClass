//
//  ClassInformation.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/2/6.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import Moya


class ClassInformation: UIViewController {

    var categoryList: [String]!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet var categoryButton: [UIButton]!
    @IBOutlet var filterCategoryButton: [UIButton]!
    @IBOutlet var filterCatButtons:[UIButton]!



    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchText.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        fillerButton.isEnabled = false
        searchText.isEnabled = false
        fillerTextField.isEnabled = false

    }
    
    @IBOutlet weak var fillerButton: UIButton!
    enum Categories: String{
        case cnum = "Course Number"
        case subject = "Subject"
        case prof = "Professor"
        case semester = "Semester"
        case title="Title"
        
    }
    @IBAction func categoryTaped(_ sender: UIButton) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            searchText.text = ""
            
        }
        guard let title = sender.currentTitle, let category = Categories(rawValue: title) else{
            return
        }
        switch category {
        case .cnum:
            print("Course Number")
            searchText.placeholder = "CS 180"
            //sender.setTitle("Course Number", for: .normal)
        case .subject:
            print("Subject")
            
            
            searchText.placeholder = "CS"
            //sender.setTitle("Subject", for: .normal)

        case .prof:
            print("Professor")
            searchText.placeholder = "Dunsmore"
            //sender.setTitle("Professor", for: .normal)

        case .semester:
            print("Semester")
            searchText.placeholder = "18 sp"
            //sender.setTitle("Semester", for: .normal)

        case .title:
            print("Title")
            searchText.placeholder = "Java"
            //sender.setTitle("Title", for: .normal)

        }
        
    }
    
@IBAction func fillerSelectCategory(_ sender: UIButton) {
        filterCatButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            fillerTextField.text = ""
            
        }
        guard let title = sender.currentTitle, let category = Categories(rawValue: title) else{
            return
        }
        switch category {
        case .cnum:
            print("Course Number")
            fillerTextField.placeholder = "CS 180"
        case .subject:
            print("Subject")
            
            
            fillerTextField.placeholder = "CS"
        case .prof:
            print("Professor")
            fillerTextField.placeholder = "Dunsmore"
        case .semester:
            print("Semester")
            fillerTextField.placeholder = "18 sp"
        case .title:
            print("Title")
            fillerTextField.placeholder = "Java"
        }
        
    }
    var searchTimer: Timer?
    @objc func textFieldDidEditingChanged(_ textField: UITextField) {
        // if a timer is already active, prevent it from firing
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textField.text!, repeats: false)
        
    }
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButton(_ sender: UIButton) {
    }
    
    @objc func searchForKeyword(_ timer: Timer) {
        
        // retrieve the keyword from user info
        let keyword = timer.userInfo!
        
        fillerButton.isEnabled = true
        searchButton.isEnabled = true
        
        print("Searching for keyword \(keyword)")
    }
    
    @IBAction func handleSelection(_ sender: UIButton) {
        categoryButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
        searchText.isEnabled = true

    }
    @IBAction func filterhandleSelection(_ sender: UIButton) {
        filterCatButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        fillerTextField.isEnabled = true
        

    }
    
    @IBOutlet weak var searchText: UITextField!
    @IBAction func searchTextField(_ sender: Any) {
    }
    @IBAction func fillerTextField(_ sender: UITextField) {
    }
    var hitFiller = false
    @IBOutlet weak var fillerSelectCategory: UIStackView!
    @IBOutlet weak var fillerTextField: UITextField!
    @IBAction func fillerButton(_ sender: UIButton) {
        if(!hitFiller){
            fillerSelectCategory.isHidden = false
            fillerTextField.isHidden = false
            hitFiller = true
        }
        else{
            fillerSelectCategory.isHidden = true
            fillerTextField.isHidden = true
            hitFiller = false
        }
            
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
