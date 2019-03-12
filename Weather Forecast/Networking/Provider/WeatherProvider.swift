//
//  WeatherProvider.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/10/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

struct WeatherProvider {
    
    static func getCurrentWeatherFor(lat: Double, lon: Double, success: @escaping (Any) -> Void, failure: @escaping (Error) -> Void) {
        
        let baseUrl = WeatherConstants.APIConstants.baseURL
        let endpoint = WeatherConstants.APIConstants.endpoints.currentWeatherEndpoint
        let latParameter = WeatherConstants.APIConstants.parameters.lat
        let lonParameter = WeatherConstants.APIConstants.parameters.lon
        
        let finalURL = "\(baseUrl)/\(endpoint)?\(latParameter)=\(lat)&\(lonParameter)=\(lon)"
        print(finalURL)
        
        Network.get(with: finalURL, success: { (response) in
            
            OperationQueue.main.addOperation {
                success(response)
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                failure(error)
            }
        }
    }
    
    static func getWeatherForecastFor(lat: Double, lon: Double, success: @escaping (Any) -> Void, failure: @escaping (Error) -> Void) {
        
        let baseUrl = WeatherConstants.APIConstants.baseURL
        let endpoint = WeatherConstants.APIConstants.endpoints.forecastEndpoint
        let latParameter = WeatherConstants.APIConstants.parameters.lat
        let lonParameter = WeatherConstants.APIConstants.parameters.lon
        
        let finalURL = "\(baseUrl)/\(endpoint)?\(latParameter)=\(lat)&\(lonParameter)=\(lon)"
        print(finalURL)
        
        Network.get(with: finalURL, success: { (response) in
            OperationQueue.main.addOperation {
                success(response)
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                failure(error)
            }
        }
        
    }
}
