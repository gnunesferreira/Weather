//
//  ForecastForTimeTests.swift
//  Weather Forecast Tests
//
//  Created by Guilherme Nunes Ferreira on 3/12/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import XCTest
@testable import Weather_Forecast

class ForecastForTimeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {

        if let path = Bundle.main.path(forResource: "ForecastPrague", ofType: "json") {
            do {

                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)

                guard let json = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? Dictionary<String,Any> else {
                    XCTFail()
                    return
                }

                guard let jsonList = json["list"] else {
                    XCTFail()
                    return
                }

                let jsonListData = try JSONSerialization.data(withJSONObject: jsonList)

                let forecastForTimeArray = try JSONDecoder().decode([ForecastForTime].self, from: jsonListData)
                XCTAssertNotNil(forecastForTimeArray)
            } catch {
                XCTFail("Parse fail")
            }
        } else {
            XCTFail("It didn't find ForecastPrague file")
        }
    }

}
