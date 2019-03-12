//
//  WeatherManager.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

import CoreLocation

enum CurrentWeatherError: Error {
    case parseError
}

struct WeatherManager {

    static func getCurrentWeather(location: CLLocationCoordinate2D, success: @escaping (LocationWeather) -> Void, failure: @escaping (Error) -> Void) {

        let lat = Double(location.latitude)
        let lon = Double(location.longitude)

        WeatherProvider.getCurrentWeatherFor(lat: lat, lon: lon, success: { (response) in

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

    static func getWeatherForecast(location: CLLocationCoordinate2D, success: @escaping (OrderedForecastForTime) -> Void, failure: @escaping (Error) -> Void) {

        let lat = Double(location.latitude)
        let lon = Double(location.longitude)

        WeatherProvider.getWeatherForecastFor(lat: lat, lon: lon, success: { (response) in

            do {
                guard let json = response as? [String: AnyObject] else { return }
                guard let jsonList = json["list"] else { return }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonList)
                let forecastForTimeArray = try JSONDecoder().decode([ForecastForTime].self, from: jsonData)

                let orderedForecast = OrderedForecastForTime(forecastForTimeArray: forecastForTimeArray)

                success(orderedForecast)
            } catch {
                failure(CurrentWeatherError.parseError)
            }
        }) { (error) in
            failure(error)
        }
    }
}
