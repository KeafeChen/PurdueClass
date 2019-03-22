//
//  PopUpWindow.swift
//  PurdueClass
//
//  Created by SH on 3/22/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import EventKit

protocol PopUpDelgate {
    func handleDismissalIOS()
    func handleDismissalGoogle()
}


class PopUpWindow: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate: PopUpDelgate?
    
    let buttonIOS: UIButton = {
        let buttonIOS = UIButton(type: .system)
        buttonIOS.backgroundColor = .white
        buttonIOS.setTitle("export to IOS Calendar", for: .normal)
        buttonIOS.setTitleColor(.blue, for: .normal)
        buttonIOS.addTarget(self, action: #selector(handleDismissalIOS), for: .touchUpInside)
        buttonIOS.translatesAutoresizingMaskIntoConstraints = false
        buttonIOS.layer.cornerRadius = 5
        return buttonIOS
    }()
    
    /* fot google calendar
    let buttonGoogle: UIButton = {
        let buttonGoogle = UIButton(type: .system)
        buttonGoogle.backgroundColor = .white
        buttonGoogle.setTitle("export to Google Calendar", for: .normal)
        buttonGoogle.setTitleColor(.blue, for: .normal)
        buttonGoogle.addTarget(self, action: #selector(handleDismissalGoogle), for: .touchUpInside)
        buttonGoogle.translatesAutoresizingMaskIntoConstraints = false
        buttonGoogle.layer.cornerRadius = 5
        return buttonGoogle
    }()
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        
        addSubview(buttonIOS)
        buttonIOS.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        buttonIOS.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200).isActive = true;
        buttonIOS.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true;
        buttonIOS.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true;

        
        /* for google calendar
        addSubview(buttonGoogle)
        buttonGoogle.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        buttonGoogle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true;
        buttonGoogle.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true;
        buttonGoogle.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true;
        */
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    @objc func handleDismissalIOS() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
        print("diss IOS")
        delegate?.handleDismissalIOS()
    }
    
    func insertEvent(store: EKEventStore) {
        let eventStore = store

        // 1
        let calendars = store.calendars(for: .event)
        print(calendars)
        
        for calendar in calendars {
            // 2
            if calendar.title == "Calendar" {
                // 3
                var local_store : Array<Array<String>> = Array()
                
                if defaults.value(forKey: "schedule") != nil {
                    local_store = defaults.array(forKey: "schedule") as! Array<Array<String>>
                }
                
                for i in local_store {
                    if (i[0] == "Spring2019"){
                        if (i[4] == "MWF"){
                            add_to(i: i, month: 3, days: [18, 20, 22, 25, 27, 29], store: eventStore, calendar: calendar)
                        } else {
                            add_to(i: i, month: 3, days: [19, 21, 26, 28], store: eventStore, calendar: calendar)
                        }
                    }
                    else if (i[0] == "Summer2019"){
                        if (i[4] == "MWF"){
                            add_to(i: i, month: 6, days: [10, 12, 14], store: eventStore, calendar: calendar)
                        } else {
                            add_to(i: i, month: 6, days: [11, 13], store: eventStore, calendar: calendar)
                        }
                    }
                }
            }
        }
    }
    
    func add_to(i : Array<String>, month: Int, days: Array<Int>, store: EKEventStore, calendar: EKCalendar){
        for j in days{
            let format = Calendar.current
            var components = DateComponents()
            
            components.day = j
            components.month = month
            components.year = 2019
            let starthour = Int(i[5].dropLast(5) as Substring)
            let startmin = Int(i[5].dropFirst(3).dropLast(2) as Substring)
            

            components.hour = starthour
            components.minute = startmin
            
            let newDate = format.date(from: components)
            
            let startDate = newDate
            
            let endhour = Int(i[6].dropLast(5) as Substring)
            let endmin = Int(i[6].dropFirst(3).dropLast(2) as Substring)
            
            components.hour = endhour
            components.minute = endmin
            
            let newDate2 = format.date(from: components)
            
            let endDate = newDate2
            
            let event = EKEvent(eventStore: store)
            event.calendar = calendar
            event.title = i[1]
            event.startDate = startDate
            event.endDate = endDate
            
            do {
                try store.save(event, span: .thisEvent)
            }
            catch {
                print("Error saving event in calendar")
            }
        }
    }
    
    @objc func handleDismissalGoogle() {
        print ("dis Google")
        delegate?.handleDismissalGoogle()
    }
}
