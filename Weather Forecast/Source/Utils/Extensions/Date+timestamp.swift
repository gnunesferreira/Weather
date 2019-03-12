//
//  Date+timestamp.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/11/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

extension Date {

    func dayMonthYearDateFromTimestamp(_ timestamp: Double) -> Date? {

        let currentDate = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.day, .month, .year], from: currentDate)
        let year = components.year
        let month = components.month
        let day = components.day

        let newDateComponents = DateComponents(year: year, month: month, day: day)
        guard let newDate = calendar.date(from: newDateComponents) else { return nil }

        return newDate
    }

    func hourMinuteFromTimestamp(_ timestamp: Double) -> String {
        let currentDate = Date(timeIntervalSince1970: timestamp)
        let hour = Calendar.current.component(.hour, from: currentDate)
        let minutes = Calendar.current.component(.minute, from: currentDate)

        return String(format: "%02d:%02d", hour, minutes)
    }

    func weekDay() -> String {
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(self) {
            return "Today"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }


}
