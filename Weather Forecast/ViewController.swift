//
//  ViewController.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        WeatherManager.getCurrentWeather(lat: -22.600968, lon: -47.417608, success: { (locationWeather) in
            print("Success")
        }) { (error) in
            print("Fail")
        }
    }
}

