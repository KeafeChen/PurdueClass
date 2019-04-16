//
//  addHW.swift
//  PurdueClass
//
//  Created by Keafe Chen on 2019/3/22.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

class addHW: UIViewController {

    var descriptionTxt = String()
    var dateTxt = String()
    var notTxt = String()
    var reviseOrNot = Bool()
    var submitTxt = String()



    private var datePicker = UIDatePicker()
    //private var ddate = Date
    override func viewDidLoad() {
        super.viewDidLoad()

        description1.text = descriptionTxt
        date.text=dateTxt
        datePicker.datePickerMode = .dateAndTime
        date.inputView = datePicker
        datePicker.addTarget(self, action: #selector(addHW.dateChanged(sender:)), for: UIControl.Event.valueChanged)
        // Do any additional setup after loading the view.
    }

    @objc func dateChanged(sender: UIDatePicker){
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.medium
        format.timeStyle = DateFormatter.Style.medium
        date.text = format.string(from: sender.date)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBOutlet weak var description1: UITextField!

    @IBOutlet weak var date: UITextField!

    @IBOutlet weak var note: UITextField!

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var submit: UIButton!


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is homework{
            let vc = segue.destination as? homework
            vc?.newDescription = description1.text!
            vc?.newDate = datePicker.date
            vc?.newNote = note.text!

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
