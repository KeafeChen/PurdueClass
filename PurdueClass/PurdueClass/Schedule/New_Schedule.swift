//
//  New_Schedule.swift
//  PurdueClass
//
//  Created by SH on 4/14/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit

var hahaha = 0

var clicked = -1

var eventToDelete : Event? = nil

class New_Schedule: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var Schedule: UICollectionView!
    
    let defaults = UserDefaults.standard
    
    let color_set = [UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 1), UIColor(red: 234/255, green: 67/255, blue: 53/255, alpha: 1), UIColor(red: 253/255, green: 189/255, blue: 4/255, alpha: 1), UIColor(red: 56/255, green: 168/255, blue: 83/255, alpha: 1), UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)]

    
    
    @IBOutlet weak var export_button: UIButton!
    @IBOutlet weak var screenshot_button: UIButton!
    
    
    lazy var popUpWindow: PopUpWindow = {
        let view = PopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    lazy var popUpBlockWindow: PopUpBlockWindow = {
        let view = PopUpBlockWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    lazy var popUpSwitchWindow: PopUpSwitchWindow = {
        let view = PopUpSwitchWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var block_index : Array<Array<Int>> = []
    var block_content : Array<Array<String>> = []
    var block_color : Array<UIColor> = []
    
    var deleteIndex : Array<Int> = []
    
    var course_value:String = ""
    var semester_value:String = ""
    var department_value:String = ""
    var professor_value:String = ""
    var detail_value:String = ""
    var weekday_value: String = ""
    var start_value: String = ""
    var end_value : String = ""
    var eventTodisplay = Event()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        export_button.addTarget(self, action: #selector(handleShowPopUp), for: .touchUpInside)
        export_button.layer.cornerRadius = 5
        screenshot_button.layer.cornerRadius = 5
        
        
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        
        visualEffectView.alpha = 0
        
        check()

    }
    
    func check(){
        var local_store : Array<Array<String>> = Array()
        
        if defaults.value(forKey: "schedule") != nil {
            local_store = defaults.array(forKey: "schedule") as! Array<Array<String>>
        }
        
        if eventList.count < local_store.count {
            eventList = []
            for i in local_store{
                var newEvent = Event();
                newEvent.semester = i[0]
                newEvent.course = i[1]
                newEvent.professor = i[2]
                newEvent.department = i[3]
                newEvent.weekday = i[4]
                newEvent.start = i[5]
                newEvent.end = i[6]
                newEvent.detail = i[7]
                eventList.append(newEvent)
            }
        }
        
        if eventList.count > local_store.count {
            local_store = []
            for i in 0...eventList.count-1{
                var temp : Array<String> = []
                temp.append(eventList[i].semester!)
                temp.append(eventList[i].course!)
                temp.append(eventList[i].professor!)
                temp.append(eventList[i].department!)
                temp.append(eventList[i].weekday!)
                temp.append(eventList[i].start!)
                temp.append(eventList[i].end!)
                temp.append(eventList[i].detail!)
                local_store.append(temp)
            }
        }
        
        //
        if course_value != "" {
            var newEvent = Event();
            newEvent.semester = semester_value
            newEvent.course = course_value
            newEvent.professor = professor_value
            newEvent.department = department_value
            newEvent.weekday = weekday_value
            newEvent.start = start_value
            newEvent.end = end_value
            newEvent.detail = detail_value
            
            var flag = true
            for xxx in eventList {
                if xxx.course == newEvent.course && xxx.start == newEvent.start {flag = false}
            }
            if flag {
                eventList.append(newEvent)
                var temp_array : Array<String> = Array()
                temp_array.append(semester_value)
                temp_array.append(course_value)
                temp_array.append(professor_value)
                temp_array.append(department_value)
                temp_array.append(weekday_value)
                temp_array.append(start_value)
                temp_array.append(end_value)
                temp_array.append(detail_value)
                local_store.append(temp_array)
                defaults.set(local_store, forKey:"schedule")
            }
        }
        
        block_index = []
        block_content = []
        block_color = []
        for event in local_store{
            var current : Array<Int> = []            
            var newnew : Array<String> = []
            
            if event[4].contains("M"){
                newnew.append(event[1])
                for i in find_index(event: event, day: 1){
                    current.append(i)
                    newnew.append("")
                }
                newnew.removeLast()
            }
            if event[4].contains("T"){
                newnew.append(event[1])
                for i in find_index(event: event, day: 2){
                    current.append(i)
                    newnew.append("")
                }
                newnew.removeLast()
            }
            if event[4].contains("W"){
                newnew.append(event[1])
                for i in find_index(event: event, day: 3){
                    current.append(i)
                    newnew.append("")
                }
                newnew.removeLast()
            }
            if event[4].contains("R"){
                newnew.append(event[1])
                for i in find_index(event: event, day: 4){
                    current.append(i)
                    newnew.append("")
                }
                newnew.removeLast()
            }
            if event[4].contains("F"){
                newnew.append(event[1])
                for i in find_index(event: event, day: 5){
                    current.append(i)
                    newnew.append("")
                }
                newnew.removeLast()
            }
            
            block_index.append(current)
            block_content.append(newnew)
            block_color.append(color_set[hahaha])   //(.random())
            hahaha += 1
            if (hahaha == 6){
                hahaha = 0
            }
        }
        
        //delete
        if eventToDelete != nil {
            for indexi in 0...(eventList.count-1){
                let xxx = eventList[indexi]
                if xxx.course == eventToDelete!.course && xxx.start == eventToDelete!.start {
                    eventList.remove(at: indexi)
                    local_store.remove(at: indexi)
                    defaults.set(local_store, forKey:"schedule")
                    deleteIndex = block_index[indexi]
                    block_index.remove(at: indexi)
                    block_color.remove(at: indexi)
                    block_content.remove(at: indexi)
                    break;
                }
            }
            eventToDelete = nil
        }
        
        //
        data.removeAll();
        data = [[],[],[],[],[],[],[]]
        
        for xxx in eventList {
            if let day = xxx.weekday {
                if day.contains("M"){ data[1].append(xxx)}
                if day.contains("T"){ data[2].append(xxx)}
                if day.contains("W"){ data[3].append(xxx)}
                if day.contains("R"){ data[4].append(xxx)}
                if day.contains("F"){ data[5].append(xxx)}
            }
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
    func find_index(event : Array<String>, day : Int) -> Array<Int>{
        var current : Array<Int> = []
        let starthour = Int(event[5].dropLast(5) as Substring)
        var startmin : Int
        if event[5].count == 6{
            startmin = Int(event[5].dropFirst(2).dropLast(2) as Substring)!
        } else {
            startmin = Int(event[5].dropFirst(3).dropLast(2) as Substring)!
        }
        
        let endhour = Int(event[6].dropLast(5) as Substring)
        var endmin : Int
        if event[6].count == 6{
            endmin = Int(event[6].dropFirst(2).dropLast(2) as Substring)!
        } else {
            endmin = Int(event[6].dropFirst(3).dropLast(2) as Substring)!
        }
        
        var start = 0
        var end = 0
        if startmin == 30 {
            start = ((starthour! - 7) * 2) * 7 + day
        } else {
            start = ((starthour! - 7) * 2 - 1) * 7 + day
        }
        if endmin == 30 || endmin == 20 || endmin == 15 {
            end = ((endhour! - 7) * 2 - 1) * 7 + day
        } else {
            end = ((endhour! - 7) * 2 - 2) * 7 + day
        }
        var stupid = 7
        for i in start...end{
            if (stupid % 7 == 0){
                current.append(i)
            }
            stupid += 1
        }

        return current
    }
    
    @IBAction func save_screenshot(_ sender: Any) {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
    }
    
    @objc func handleShowPopUp() {
        
        view.addSubview(popUpWindow)
        popUpWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        popUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        popUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpWindow.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.popUpWindow.alpha = 1
            self.popUpWindow.transform = CGAffineTransform.identity
        }
        print("Show pop up window..")
    }
    
    @objc func handleShowBlockPopUp(sender: UIButton) {
        for i in 0...block_index.count-1 {
            if block_index[i].contains(sender.tag){
                clicked = i
            }
        }
        
        popUpBlockWindow.show = true
        
        view.addSubview(popUpBlockWindow)
        popUpBlockWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        popUpBlockWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpBlockWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        popUpBlockWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        popUpBlockWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpBlockWindow.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.popUpBlockWindow.alpha = 1
            self.popUpBlockWindow.transform = CGAffineTransform.identity
        }
        
        print("Show pop up window..")
    }
    
    @objc func handleShowSwitchPopUp() {
  
        popUpSwitchWindow.show = true
        
        view.addSubview(popUpSwitchWindow)
        popUpSwitchWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        popUpSwitchWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpSwitchWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        popUpSwitchWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        popUpSwitchWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpSwitchWindow.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.popUpSwitchWindow.alpha = 1
            self.popUpSwitchWindow.transform = CGAffineTransform.identity
        }
        
        print("Show pop up window..")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 168
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Schedule", for: indexPath) as! BlockCollectionViewCell
        print(indexPath)
        cell.block_label.text = "\(indexPath.row + 1)"
        */
  
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Schedule", for: indexPath) as? BlockCollectionViewCell{
            cell.configureCell(title: "")
            cell.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            cell.block_button.removeTarget(self, action: #selector(handleShowBlockPopUp), for: .touchUpInside)
        
            if block_index.count > 0{
                for i in 0...block_index.count-1 {
                    for j in 0...block_index[i].count-1{
                        if block_index[i][j] == indexPath.row {
                            cell.configureCell(title: block_content[i][j])
                            cell.backgroundColor = block_color[i]
                            cell.block_button.tag = indexPath.row
                            cell.block_button.addTarget(self, action: #selector(handleShowBlockPopUp), for: .touchUpInside)
                            break;
                        }
                    }
                }
            }
            
            return cell
        }
        self.deleteIndex = []
        return UICollectionViewCell()
    }
    
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


extension New_Schedule: PopUpDelgate {
    func handleDismissalIOS() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpWindow.removeFromSuperview()
            print("remove pop up ios")
        }
    }
    func handleDismissalGoogle(){
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpWindow.alpha = 0
            self.popUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpWindow.removeFromSuperview()
            print("remove pop up ios")
        }
    }


}

extension New_Schedule: PopUpBlockDelgate {
    func handleDismissal() {
        viewDidLoad()
        Schedule.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpBlockWindow.alpha = 0
            self.popUpBlockWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpBlockWindow.removeFromSuperview()
            print("remove pop up ios")
        }
    }
    func handleDelete(){
        eventToDelete = eventList[clicked]
        viewDidLoad()
        Schedule.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpBlockWindow.alpha = 0
            self.popUpBlockWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpBlockWindow.removeFromSuperview()
            print("remove pop up ios")
        }
    }
    
    func handleSwitch(){
        handleShowSwitchPopUp()
    }
}

extension New_Schedule: PopUpSwitchDelgate {
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpSwitchWindow.alpha = 0
            self.popUpSwitchWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpSwitchWindow.removeFromSuperview()
            print("remove pop up ios")
        }
    }
    
    func handleSwitchSession(){
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.popUpSwitchWindow.alpha = 0
            self.popUpSwitchWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.popUpSwitchWindow.removeFromSuperview()
            print("remove pop up ios")
        }
    }
}
