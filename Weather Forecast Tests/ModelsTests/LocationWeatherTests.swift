//
//  LocationWeatherTests.swift
//  Weather Forecast Tests
//
//  Created by Guilherme Nunes Ferreira on 3/12/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import XCTest
@testable import Weather_Forecast

class LocationWeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {

        if let path = Bundle.main.path(forResource: "WeatherPrague", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let locationWeather = try JSONDecoder().decode(LocationWeather.self, from: jsonData)
                XCTAssertNotNil(locationWeather)
            } catch {
                XCTFail("Parse fail")
            }
        } else {
            XCTFail("It didn't find WeatherPrague file")
        }
    }
}
