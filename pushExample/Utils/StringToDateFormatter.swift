//
//  StringToDateFormatter.swift
//  pushExample
//
//  Created by Alok Kulkarni on 15/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import Foundation

class stringToDate {
    
    static let sharedInstance = stringToDate()
    
    func StringToDateFormat(dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:dateString)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        return finalDate!
    }
    
}
