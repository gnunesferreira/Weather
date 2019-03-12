//
//  OrderedForecastForTime.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/10/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

struct OrderedForecastForTime {

    var timeArray: [Date]
    var forecastDictionary: [Date: [ForecastForTime]]

    init(forecastForTimeArray: [ForecastForTime]) {

        var partialTimeArray = [Date]()
        var partialForecastDictionary = [Date: [ForecastForTime]]()

        forecastForTimeArray.forEach { (forecastForTime) in

            guard let dayMonthYearDate = Date().dayMonthYearDateFromTimestamp(Double(forecastForTime.date)) else { return }

            if partialTimeArray.contains(dayMonthYearDate) {
                guard var forecastArrayForDate = partialForecastDictionary[dayMonthYearDate] else { return }
                forecastArrayForDate.append(forecastForTime)
                partialForecastDictionary[dayMonthYearDate] = forecastArrayForDate
            } else {

                if partialTimeArray.isEmpty {
                    partialTimeArray.append(dayMonthYearDate)
                } else {
                    if let index = partialTimeArray.index(where: { $0 < dayMonthYearDate }) {
                        partialTimeArray.insert(dayMonthYearDate, at: index)
                    }
                }

                partialForecastDictionary[dayMonthYearDate] = [forecastForTime]
            }
        }

        timeArray = partialTimeArray.reversed()
        forecastDictionary = partialForecastDictionary
    }
}
