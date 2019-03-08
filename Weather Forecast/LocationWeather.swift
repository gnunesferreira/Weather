//
//  LocationWeather.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

struct LocationWeather: Codable {
    
    let cityName: String
    let country: String
    let temperature: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windDirection: Double

    enum RootKeys: String, CodingKey {
        case cityName = "name"
        case system = "sys"
        case main = "main"
        case wind = "wind"
    }

    enum SystemCodingKeys: String, CodingKey {
        case country = "country"
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

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: RootKeys.self)
        cityName = try container.decode(String.self, forKey: .cityName)

        /// Parse properties inside "sys" key
        let systemContainer = try container.nestedContainer(keyedBy: SystemCodingKeys.self, forKey: .system)
        country = try systemContainer.decode(String.self, forKey: .country)

        /// Parse properties inside "main" key
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        temperature = try mainContainer.decode(Double.self, forKey: .temperature)
        humidity = try mainContainer.decode(Double.self, forKey: .humidity)
        pressure = try mainContainer.decode(Double.self, forKey: .pressure)

        /// Parse properties inside "wind" key
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        windSpeed = try windContainer.decode(Double.self, forKey: .speed)
        windDirection = try windContainer.decode(Double.self, forKey: .deg)
    }
}
