//
//  BackendCourseInfo.swift
//  PurdueClass
//
//  Created by H. on 2/16/19.
//  Copyright © 2019 Qifeng Chen. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB

class BackendCourseInfo: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    @objc var courseId: String?
    @objc var professor: String?
    @objc var course: String?
    @objc var department: String?
    @objc var semester: String?
    @objc var title: String?
    @objc var detail: String?
    @objc var hwDescription: String?
    @objc var hwDue: String?

    
 
    class func dynamoDBTableName() -> String {
        
        return "csproject-mobilehub-1949109104-BackendCourseInfo"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "courseId"
    }
    
}
