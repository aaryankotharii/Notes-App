//
//  Extensions.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit


extension Date {
    var stringValue : String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        let string = formatter.string(from: self)
        
        return string
    }
}

extension String {
    var dateValue : Date {
        
        let isoDate = self

        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        let date = dateFormatter.date(from:isoDate) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        
        return finalDate!
    }
}

