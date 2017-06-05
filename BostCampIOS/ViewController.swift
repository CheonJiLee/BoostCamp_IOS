//
//  ViewController.swift
//  BostCampIOS
//
//  Created by 이천지 on 2017. 5. 29..
//  Copyright © 2017년 project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var studentArr = [Student]()
    var passStudentArr = [Student]()
    var userDirName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0]
        let dirNameArr = paths.characters.split{$0 == "/"}.map(String.init)
        
        userDirName = (dirNameArr[1])
        readJson()
        writeTXT()
    }
    
    private func readJson() {
        do{
            let fileName = "students"
            let dir = FileManager.default.urls (for: .userDirectory , in: .allDomainsMask)[0]
            let nameAdd = dir.appendingPathComponent(userDirName)
            
            let fileURL = nameAdd.appendingPathComponent(fileName).appendingPathExtension("json")
            
            do {
                let data = try Data(contentsOf: fileURL)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                if let object = json as? [Any] {
                    for idx in object{
                        let student = idx as! [String:AnyObject]
                        let setStudent = Student(json: student)
                        studentArr.append(setStudent!)
                    }
                } else {
                    print("JSON is invalid")
                }
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
            studentArr.sort(by: self.before)
        }
    }
    
    func before(value1: Student, value2: Student) -> Bool {
        return value1.name < value2.name;
    }
    
    func setTXTContent()->String{
        var outString = ""
        outString += "성적결과표\n\n"
        outString += "전체 평균 : \(String(format: "%.2f\n\n", getTotalAverage()))"
        outString += "개인별 학점\n"
        
        for student in studentArr {
            outString += (student.name).padding(toLength: 15, withPad: " ", startingAt: 0)
            outString += ":\(student.grade!)\n"
        }
        
        outString += "\n수료생\n"
        for student in passStudentArr {
            outString += "\(student.name), "
        }
        return outString
    }
    
    
    
    
    func writeTXT(){
        
        let fileName = "result"
        let dir = FileManager.default.urls (for: .userDirectory , in: .allDomainsMask)[0]
        let nameAdd = dir.appendingPathComponent(userDirName)
        let fileURL = nameAdd.appendingPathComponent(fileName).appendingPathExtension("txt")
        let outString = setTXTContent()
        
        do {
            try outString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    func getGrade(score:Int) -> Character{
        switch score {
        case 90...100:
            return "A"
        case 80..<90:
            return "B"
        case 70..<80:
            return "C"
        case 60..<70:
            return "D"
        default:
            return "F"
        }
    }
    
    func getTotalAverage()-> Double{
        var allTotalScore:Int = 0
        var allSubjectCount:Int = 0
        for student in studentArr {
            var curTotalScore:Int = 0
            var curSubjectCount:Int = 0
            var curAvgScore = 0
            
            if student.algorithm != nil{
                curTotalScore += student.algorithm!
                curSubjectCount += 1
            }
            if student.data_structure != nil{
                curTotalScore += student.data_structure!
                curSubjectCount += 1
            }
            if student.database != nil{
                curTotalScore += student.database!
                curSubjectCount += 1
            }
            if student.networking != nil{
                curTotalScore += student.networking!
                curSubjectCount += 1
            }
            if student.operating_system != nil{
                curTotalScore += student.operating_system!
                curSubjectCount += 1
            }
            
            allTotalScore += curTotalScore
            allSubjectCount += curSubjectCount
            
            curAvgScore = curTotalScore / curSubjectCount
            student.grade = getGrade(score: curAvgScore)
            
            if(curAvgScore >= 70){
                passStudentArr.append(student)
            }
        }
        
        return Double(allTotalScore) / Double(allSubjectCount)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

