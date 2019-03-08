//
//  WeatherManager.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

enum CurrentWeatherError: Error {
    case parseError
}

struct WeatherManager {

    static func getCurrentWeather(lat: Double, lon: Double, success: @escaping (LocationWeather) -> Void, failure: @escaping (Error) -> Void) {

        let baseUrl = WeatherConstants.APIConstants.baseURL
        let endpoint = WeatherConstants.APIConstants.endpoints.currentWeatherEndpoint
        let latParameter = WeatherConstants.APIConstants.parameters.lat
        let lonParameter = WeatherConstants.APIConstants.parameters.lon

        let finalURL = "\(baseUrl)/\(endpoint)?\(latParameter)=\(lat)&\(lonParameter)=\(lon)"
        print(finalURL)

        Network.get(with: finalURL, success: { (response) in

            do {
                let jsonData = try JSONSerialization.data(withJSONObject:response)
                let locationWeather = try JSONDecoder().decode(LocationWeather.self, from: jsonData)
                success(locationWeather)
            }
            catch {
                failure(CurrentWeatherError.parseError)
            }
        }) { (error) in
            failure(error)
        }
    }
}
