//
//  Utils.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 21/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//
import Foundation

func convertToDateTimeFormat(dateString: String, timeString: String) -> String {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "dd/MM/yyyy"
    guard let date = dateFormatter.date(from: dateString) else {
        return ""
    }

    dateFormatter.dateFormat = "hh:mm a"
    guard let time = dateFormatter.date(from: timeString) else {
        return ""
    }
 
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: time)
    let minute = calendar.component(.minute, from: time)
    let second = 0
    
    let finalDate = calendar.date(bySettingHour: hour, minute: minute, second: second, of: date)
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter.string(from: finalDate!)
}

func getCurrentDate() -> String {
    let dateFormatter = DateFormatter()
    let currentLocale = Locale.current.languageCode
    
    let currentDate = Date()

    if currentLocale == "vi" {
        dateFormatter.dateFormat = "dd MMMM, yyyy"
    } else {
        dateFormatter.dateFormat = "MMMM dd, yyyy"
    }
    
    let formattedDate = dateFormatter.string(from: currentDate)
    return formattedDate
}
