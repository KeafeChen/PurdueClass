//
//  PopUpWindow.swift
//  PurdueClass
//
//  Created by SH on 3/22/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import EventKit
import AWSDynamoDB
import AWSCore

protocol PopUpSwitchDelgate {
    func handleDismiss()
    func handleSwitchSession()
}

var switchable : Array<Event> = []
var buttons: Array<UIButton> = []

class PopUpSwitchWindow: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    let defaults = UserDefaults.standard
    
    var delegate: PopUpSwitchDelgate?
    
    var check = false
    
    var track : Int = 0
    
    let dispatchGroup = DispatchGroup()
    
    var show : Bool? {
        didSet {
            guard let success = show else { return }
            if success {
                searchSession()
            }
        }
    }
    
    
    let buttonIOS: UIButton = {
        let buttonIOS = UIButton(type: .system)
        buttonIOS.backgroundColor = .white
        buttonIOS.setTitle("Back", for: .normal)
        buttonIOS.setTitleColor(UIColor(red: 207/255, green: 163/255, blue: 74/255, alpha: 1.0), for: .normal)
        buttonIOS.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        buttonIOS.translatesAutoresizingMaskIntoConstraints = false
        buttonIOS.layer.cornerRadius = 5
        return buttonIOS
    }()
    
    let switchButton: UIButton = {
        let switchButton = UIButton(type: .system)
        switchButton.backgroundColor = .white
        switchButton.setTitle("Switch", for: .normal)
        switchButton.setTitleColor(UIColor(red: 207/255, green: 163/255, blue: 74/255, alpha: 1.0), for: .normal)
        switchButton.addTarget(self, action: #selector(handleSwitchSession), for: .touchUpInside)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.layer.cornerRadius = 5
        return switchButton
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 207/255, green: 163/255, blue: 74/255, alpha: 1.0)

        buttons = []
      
        for i in 0...4{
            let button : UIButton = {
                let button = UIButton(type: .system)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.titleLabel!.adjustsFontSizeToFitWidth = true
                button.setTitleColor(UIColor(red: 207/255, green: 163/255, blue: 74/255, alpha: 1.0), for: .normal)
                button.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
                button.backgroundColor = .white
            return button
            }()
            buttons.append(button)
        }
      
        for i in 0...buttons.count-1{
            addSubview(buttons[i])
            buttons[i].leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            buttons[i].rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
            buttons[i].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: CGFloat(-300+50*i)).isActive = true
            buttons[i].heightAnchor.constraint(equalToConstant: 20).isActive = true;
            buttons[i].tag = i
        }
        
        
        //searchSession()

        
        addSubview(buttonIOS)
        buttonIOS.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonIOS.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        buttonIOS.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        buttonIOS.rightAnchor.constraint(equalTo: rightAnchor, constant: -240).isActive = true
        buttonIOS.titleLabel!.adjustsFontSizeToFitWidth = true
        
        
        addSubview(switchButton)
        switchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        switchButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 240).isActive = true
        switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        switchButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    // back button
    @objc func handleDismiss() {
        delegate?.handleDismiss()
        self.track = -1
    }
    
    // switch button
    @objc func handleSwitchSession() {
        if self.track != -1{
            eventList.append(switchable[self.track])
        }
        delegate?.handleSwitchSession()
        self.track = -1
    }
    
    // click on the session
    @objc func handleSwitch(sender: UIButton){
        eventToDelete = eventList[clicked]
        //eventList.remove(at: clicked)
        self.track = sender.tag
    }
    
    func searchSession(){
        dispatchGroup.enter()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        
        
        var localDictionary: [String: Any] = [:]
        var localFilterExpression: String? = nil
        
        localFilterExpression = "course = :course "
        localDictionary.updateValue(eventList[clicked].course!, forKey: ":course")
        
        queryExpression.expressionAttributeValues = localDictionary
        
        queryExpression.filterExpression = localFilterExpression
        
        objectMapper.scan(BackendCourseInfo.self, expression: queryExpression, completionHandler:
            {(response: AWSDynamoDBPaginatedOutput?, error:Error?) -> Void in
                if let error = error{
                    print("Amazon Sever error \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("querying")
                    switchable  = []
                    for i in buttons{
                        i.setTitle("", for: .normal)
                    }
                    if(response != nil){
                        print("we got response")
                        if(response?.items.count == 0){
                            print("it was 0")
                        }else{
                            self.check = true
                            for item in (response?.items)! {
                                var newEvent = Event();
                                newEvent.semester = item.value(forKey: "semester") as? String
                                newEvent.course = item.value(forKey: "course") as? String
                                newEvent.professor = item.value(forKey: "professor") as? String
                                newEvent.department = item.value(forKey: "department") as? String
                                newEvent.weekday = item.value(forKey: "weekday") as? String
                                newEvent.start = item.value(forKey: "start") as? String
                                newEvent.end = item.value(forKey: "end") as? String
                                newEvent.detail = item.value(forKey: "detail") as? String
                                switchable.append(newEvent)
                            }
                            if (switchable.count > 0){
                                for i in 0...switchable.count - 1 {
                                    let s1 : String = "Weekday: " + switchable[i].weekday!
                                    let s2 : String = ", Time: " + switchable[i].start!
                                    let s3 : String = " - " + switchable[i].end!
                                    buttons[i].setTitle(s1 + s2 + s3, for: .normal)
                                }
                            }
                        }
                    }
                    self.dispatchGroup.leave()
                }
            }
        )
    }
}
