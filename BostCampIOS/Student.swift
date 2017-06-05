//
//  Student.swift
//  BostCampIOS
//
//  Created by 이천지 on 2017. 5. 29..
//  Copyright © 2017년 project. All rights reserved.
//

//import Foundation

class Student {
    let name:String
    let operating_system:Int?
    let database:Int?
    let networking:Int?
    let algorithm:Int?
    let data_structure:Int?
    var grade:Character?
    
    init?(json: [String:Any]) {
        
        let subjects = json["grade"] as? [String:AnyObject]
        self.name = (json["name"] as? String)!
        
        self.operating_system = subjects?["operating_system"] as? Int
        self.database = subjects?["database"] as? Int
        self.networking = subjects?["networking"] as? Int
        self.algorithm = subjects?["algorithm"] as? Int
        self.data_structure = subjects?["data_structure"] as? Int
    }
    
}
