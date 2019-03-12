//
//  Constants.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

struct WeatherConstants {

    struct APIConstants {

        static let baseURL = "https://api.openweathermap.org/data/2.5"

        struct endpoints {
            static let currentWeatherEndpoint = "weather"
            static let forecastEndpoint = "forecast"
        }

        struct parameters {
            
            static let lat = "lat"
            static let lon = "lon"

            static let appId = "appid"
            static let appIdValue = "1188d8014bd9897bb96a960b8d7f7cc7"
        }
    }
}
