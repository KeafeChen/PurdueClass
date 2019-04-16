//
//  PopUpWindow.swift
//  PurdueClass
//
//  Created by SH on 3/22/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import UIKit
import EventKit

protocol PopUpSwitchDelgate {
    func handleDismiss()
    func handleSwitchSession()
}


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
    
    var show : Bool? {
        didSet {
            guard let success = show else { return }
            if success {
                detail_course.text = "COURSE: " + eventList[clicked].course!
                detail_semester.text = "SEMESTER: " + eventList[clicked].semester!
                detail_department.text = "DEPARTMENT: " + eventList[clicked].department!
                detail_professor.text = "PROFESSOR: " + eventList[clicked].professor!
                detail_weekday.text = "WEEKDAY: " + eventList[clicked].weekday!
                detail_start.text = "SESSION STARTS TIME: " + eventList[clicked].start!
                detail_end.text = "SESSION ENDS TIME: " + eventList[clicked].end!
                detail_detail.text = "DEATIL: " + eventList[clicked].detail!
            }
        }
    }
    
    let detail_course : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    let detail_semester : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    let detail_department : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    let detail_professor : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    
    let detail_weekday: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    
    let detail_start : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    
    let detail_end : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    
    let detail_detail : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    
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
        backgroundColor = UIColor(red: 207/255, green: 163/255, blue: 74/255, alpha: 1.0)
        
        
        addSubview(detail_course)
        detail_course.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -120).isActive = true
        detail_course.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(detail_semester)
        detail_semester.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        detail_semester.topAnchor.constraint(equalTo: detail_course.bottomAnchor, constant: 10).isActive = true
        
        addSubview(detail_department)
        detail_department.topAnchor.constraint(equalTo: detail_semester.bottomAnchor, constant: 10).isActive = true
        detail_department.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
        
        
        addSubview(detail_professor)
        detail_professor.topAnchor.constraint(equalTo: detail_department.bottomAnchor, constant: 10).isActive = true
        detail_professor.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        addSubview(detail_weekday)
        detail_weekday.topAnchor.constraint(equalTo: detail_professor.bottomAnchor, constant: 10).isActive = true
        detail_weekday.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        addSubview(detail_start)
        detail_start.topAnchor.constraint(equalTo: detail_weekday.bottomAnchor, constant: 10).isActive = true
        detail_start.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        addSubview(detail_end)
        detail_end.topAnchor.constraint(equalTo: detail_start.bottomAnchor, constant: 10).isActive = true
        detail_end.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(detail_detail)
        detail_detail.topAnchor.constraint(equalTo: detail_end.bottomAnchor, constant: 10).isActive = true
        detail_detail.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
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
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    @objc func handleSwitchSession() {
        delegate?.handleSwitchSession()
    }
    
}
