//
//  LocationWeather.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit

enum CurrentDayPeriod {
    case night
    case day
}

struct LocationWeather: Codable {
    
    let cityName: String
    let country: String
    let temperature: Double
    let weatherStatus: String
    let description: String
    let humidity: Double
    let pressure: Double
    let preciptation: Double?
    let windSpeed: Double
    let windDirection: Double?
    let sunrise: Int
    let sunset: Int

    enum RootKeys: String, CodingKey {
        case cityName = "name"
        case weather = "weather"
        case system = "sys"
        case main = "main"
        case wind = "wind"
        case preciptation
    }

    enum SystemCodingKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
    }

    enum MainCodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
        case pressure
    }

    enum WindCodingKeys: String, CodingKey {
        case speed
        case deg
    }

    enum PreciptationCodingKeys: String, CodingKey {
        case value
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: RootKeys.self)
        cityName = try container.decode(String.self, forKey: .cityName)

        let weatherDescriptionArray = try container.decode([Weather].self, forKey: .weather)
        if let firstWeather = weatherDescriptionArray.first {
            weatherStatus = firstWeather.main
            description = firstWeather.description
        } else {
            weatherStatus = ""
            description = ""
        }

        /// Parse properties nested in "sys" key
        let systemContainer = try container.nestedContainer(keyedBy: SystemCodingKeys.self, forKey: .system)
        country = try systemContainer.decode(String.self, forKey: .country)
        sunrise = try systemContainer.decode(Int.self, forKey: .sunrise)
        sunset = try systemContainer.decode(Int.self, forKey: .sunset)

        /// Parse properties nested in "main" key
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        temperature = try mainContainer.decode(Double.self, forKey: .temperature)
        humidity = try mainContainer.decode(Double.self, forKey: .humidity)
        pressure = try mainContainer.decode(Double.self, forKey: .pressure)

        /// Parse properties nested in "wind" key
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        windSpeed = try windContainer.decode(Double.self, forKey: .speed)

        if windContainer.contains(.deg) {
            windDirection = try windContainer.decode(Double.self, forKey: .deg)
        }
        else {
            windDirection = nil
        }

        /// Parse properties nested in "preceptation" key
        if container.contains(.preciptation) {
            let preciptationContainer = try container.nestedContainer(keyedBy: PreciptationCodingKeys.self, forKey: .preciptation)
            if preciptationContainer.contains(.value) {
                preciptation = try preciptationContainer.decode(Double.self, forKey: .value)
            }
            else {
                preciptation = nil
            }
        } else {
            preciptation = nil
        }
    }

    func getCurrentWeatherImage() -> UIImage? {

        let periodString = currentPeriod() == .day ? "day" : "night"
        let imageName = "big \(description.lowercased()) (\(periodString))"
        let image = UIImage(named: imageName)

        print(imageName)

        return image
    }

    private func currentPeriod() -> CurrentDayPeriod {

        let sunriseDate = Date(timeIntervalSince1970: Double(sunrise))
        let sunsetDate = Date(timeIntervalSince1970: Double(sunset))
        let currentDate = Date()
        var result: CurrentDayPeriod = .day

        if currentDate.compare(sunriseDate) == .orderedAscending {
            result = .night
        } else if currentDate.compare(sunsetDate) == .orderedDescending {
            result = .night
        }

        print("Current period of day \(result)")

        return result
    }

    func windDirectionString() -> String {

        guard let direction = windDirection else {
            return "-"
        }

        var windDirectionString = ""

        if direction < 22.5 {
            windDirectionString = "N"
        } else if direction < 67.5 {
            windDirectionString = "NE"
        } else if direction < 112.5{
            windDirectionString = "L"
        } else if direction < 157.5 {
            windDirectionString = "SE"
        } else if direction < 202.5 {
            windDirectionString = "S"
        } else if direction < 247.5 {
            windDirectionString = "SW"
        } else if direction < 292.5 {
            windDirectionString = "W"
        } else if direction < 337.5 {
            windDirectionString = "NW"
        } else {
            windDirectionString = "N"
        }

        return windDirectionString
    }
}
