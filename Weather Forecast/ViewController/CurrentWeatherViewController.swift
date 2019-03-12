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

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var connectionErrorView: UIView!
    @IBOutlet weak var permissionErrorView: UIView!

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
        } else {
            showPermissionError()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Today"
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard let currenWeather = locationWeather else { return }
        navigationController?.navigationBar.topItem?.title = currenWeather.cityName
    }

    // MARK: - Request method

    private func requestCurrentWeather(coordinate: CLLocationCoordinate2D) {

        LoadingView.show()

        errorView.isHidden = true
        connectionErrorView.isHidden = true
        permissionErrorView.isHidden = true

        WeatherManager.getCurrentWeather(location: coordinate, success: { [weak self](locationWeather) in

            guard let weakSelf = self else { return }
            LoadingView.dismiss()
            weakSelf.locationWeather = locationWeather
            weakSelf.updateScreen()
            weakSelf.contentView.isHidden = false
        }) { [weak self] (error) in
            LoadingView.dismiss()
            self?.showConnectionError()
        }
    }

    // MARK: - Layout methods

    private func updateScreen() {

        guard let currentWeather = locationWeather else { return }

        weatherImageView.image = currentWeather.getCurrentWeatherImage()
        locationLabel.text = "\(currentWeather.country), \(currentWeather.cityName)"
        temperatureLabel.text = "\(Int(currentWeather.temperature - 273.15))° C"
        weatherDescriptionLabel.text = "\(currentWeather.description)"
        humidityLabel.text = "\(currentWeather.humidity) %"
        pressureLabel.text = "\(currentWeather.pressure) hPa"
        windLabel.text = "\(currentWeather.windSpeed) km/h"
        windDirectionLabel.text = currentWeather.windDirectionString()

        var preciptationString = "-"
        if let preciptation = currentWeather.preciptation {
            preciptationString = "\(preciptation)mm"
        }
        preciptationLabel.text = preciptationString
    }

    private func showConnectionError() {
        errorView.isHidden = false
        connectionErrorView.isHidden = false
        permissionErrorView.isHidden = true
    }

    private func showPermissionError() {
        errorView.isHidden = false
        connectionErrorView.isHidden = true
        permissionErrorView.isHidden = false
    }

    // MARK: - IBAction

    @IBAction func tryAgainAction(_ sender: Any) {

        errorView.isHidden = true
        connectionErrorView.isHidden = true
        permissionErrorView.isHidden = true

        guard let currentCoordinate = locationManager.location?.coordinate else { return }
        requestCurrentWeather(coordinate: currentCoordinate)
    }

    @IBAction func shareAction(_ sender: Any) {

        guard let currentLocationWeather = locationWeather else { return }

        let currentWeatherMessage = "Hi, look the current weather here:\n\(currentLocationWeather.country), \(currentLocationWeather.cityName)\nTemperature: \(Int(currentLocationWeather.temperature - 273.15))° C\n\(currentLocationWeather.weatherStatus)"
        let activityViewController = UIActivityViewController(activityItems: [currentWeatherMessage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
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

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .notDetermined:
            showPermissionError()
        case .restricted:
            showPermissionError()
        case .denied:
            showPermissionError()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        showPermissionError()
    }
}

