//
//  DateService.swift
//  ImageFeed
//
//  Created by Alexey on 07.05.2023.
//

import Foundation

final class DateService {
    let dateFormatter = DateFormatter()
    let isoDateFormatter = ISO8601DateFormatter()
    
    func dateToString(date: Date?) -> String {
        guard let date = date else { return ""}
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func toDate(_ string: String) -> Date? {
        let date = isoDateFormatter.date(from: string)
        return date
    }
}
