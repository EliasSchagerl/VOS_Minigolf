//
//  Date+Extensions.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 20.10.25.
//

import Foundation

extension Date {
    
    init(_ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self = dateFormatter.date(from: dateString) ?? Date()
    }
}
