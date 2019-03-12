//
//  File.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import Foundation

import Alamofire

enum NetworkError: Error {
    case requestIssue
    case networkIssue
}

class Network {
    
    static func get(with url: URLConvertible, success: @escaping (Any) -> Void, failure: @escaping (Error) -> Void) {
        
        let appIdKeyParameter = WeatherConstants.APIConstants.parameters.appId
        let appIdValue = WeatherConstants.APIConstants.parameters.appIdValue
        
        let finalURL = "\(url)&\(appIdKeyParameter)=\(appIdValue)"
        
        print("[Network.get(with:success:failure:)] finalURL \(finalURL)")
        
        Alamofire.request(finalURL).responseJSON { (dataResponse) in
            
            if let json = dataResponse.result.value {
                print("[Network.get(with:success:failure:)] Request succeded")
                success(json)
            }
            else {
                print("[Network.get(with:success:failure:)] Request failed")
                failure(NetworkError.requestIssue)
            }
        }
    }
}
