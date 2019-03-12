//
//  ForecastForTime.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit

struct ForecastForTime: Codable {

    let date: Int
    let temperature: Double
    let weatherStatus: String
    let weatherDescription: String

    enum RootCodingKey: String, CodingKey {
        case date = "dt"
        case main = "main"
        case weather = "weather"
    }

    enum MainCodingKey: String, CodingKey {
        case temperature = "temp"
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: RootCodingKey.self)
        date = try container.decode(Int.self, forKey: .date)

        let weatherDescriptionArray = try container.decode([Weather].self, forKey: .weather)
        if let firstWeather = weatherDescriptionArray.first {
            weatherStatus = firstWeather.main
            weatherDescription = firstWeather.description
        } else {
            weatherStatus = ""
            weatherDescription = ""
        }

        /// Parse properties nested in "main" key
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKey.self, forKey: .main)
        temperature = try mainContainer.decode(Double.self, forKey: .temperature)
    }

    func getCurrentWeatherImage() -> UIImage? {

        let imageName = "medium \(weatherStatus.lowercased())"
        let image = UIImage(named: imageName)
        
        return image
    }
}




