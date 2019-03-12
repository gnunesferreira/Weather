//
//  CurrentWeatherViewController.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/8/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var preciptationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!

    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private var locationWeather: LocationWeather?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.isHidden = true

        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Request method

    private func requestCurrentWeather(coordinate: CLLocationCoordinate2D) {

        LoadingView.show()

        WeatherManager.getCurrentWeather(location: coordinate, success: { [weak self](locationWeather) in

            guard let weakSelf = self else { return }
            LoadingView.dismiss()
            weakSelf.locationWeather = locationWeather
            weakSelf.updateScreen()
            weakSelf.contentView.isHidden = false
        }) { [weak self] (error) in
            LoadingView.dismiss()
        }
    }

    // MARK: - Layout methods

    private func updateScreen() {

        guard let currentWeather = locationWeather else { return }

        weatherImageView.image = currentWeather.getCurrentWeatherImage()
        locationLabel.text = "\(currentWeather.country), \(currentWeather.cityName)"
        temperatureLabel.text = "\(Int(currentWeather.temperature - 273.15))°C"
        weatherDescriptionLabel.text = "\(currentWeather.description)"
        humidityLabel.text = "\(currentWeather.humidity)%"
        pressureLabel.text = "\(currentWeather.pressure)hPa"
        windLabel.text = "\(currentWeather.windSpeed)km/h"
        windDirectionLabel.text = "\(currentWeather.windDirection)"
    }
}

// MARK: - CLLocationManagerDelegate

extension CurrentWeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        guard let currentCoordinate = locations.first?.coordinate else { return }
        requestCurrentWeather(coordinate: currentCoordinate)
    }
}

