//
//  File.swift
//  AssignmentSwift
//
//  Created by Vijay Chavre on 05/01/18.
//  Copyright © 2018 Vijay Chavre. All rights reserved.
//
import UIKit
class User: NSObject {
    var userName: String = ""
    var photoUrl: String = ""
    var tagLine: String = ""
    var age: Int?
    
    init(userName: String, photoUrl: String, tagLine: String, age: Int ) {
        self.userName = userName
        self.photoUrl = photoUrl
        self.tagLine = tagLine
        self.age = age
    }
}

