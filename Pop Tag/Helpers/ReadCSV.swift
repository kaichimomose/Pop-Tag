//
//  ReadCSV.swift
//  Pop Tag
//
//  Created by Kaichi Momose and Melody Yang on 2018/04/13.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import Foundation

final class ReadCSV {
    
    let fileName: String
    let days: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func getCSVrows() -> [[String]] {
        var data = readDataFromCSV(fileName: self.fileName, fileType: ".csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        return csvRows
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func collectHourBasedOnDay(day: String) -> [Double] {
        let csvRows = getCSVrows()
        var rates = [Double]()
        
        for i in 1..<csvRows.count - 1 {
            if  csvRows[i][3] == day {
                rates.append(Double(String(format: "%.2f", Double(csvRows[i][1])!))!)
            } else {
                
            }
        }
        
        return rates
    }
    
    func createDictionaryGrouthRate() -> [String:[Double]]{
        var dayDictionary = [String:[Double]]()
        for day in days {
            dayDictionary[day] = collectHourBasedOnDay(day: day)
        }
        return dayDictionary
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
}
