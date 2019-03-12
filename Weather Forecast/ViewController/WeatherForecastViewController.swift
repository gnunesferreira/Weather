//
//  WeatherForecastViewController.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/11/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherForecastViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var connectionErrorView: UIView!
    @IBOutlet weak var permissionErrorView: UIView!

    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private var orderedForecast: OrderedForecastForTime?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isHidden = true

        initTableView()
        initLocationManager()
    }

    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WeatherForecastTableViewCell", bundle: nil), forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        tableView.register(UINib(nibName: "WeatherForecastHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: WeatherForecastHeaderView.identifier)
    }

    private func initLocationManager() {

        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            showPermissionError()
        }
    }

    // MARK: - Request

    private func requestWeatherForecastFor(coordinate: CLLocationCoordinate2D) {

        LoadingView.show()

        errorView.isHidden = true
        connectionErrorView.isHidden = true
        permissionErrorView.isHidden = true

        WeatherManager.getWeatherForecast(location: coordinate, success: { [weak self](orderedForecast) in

            LoadingView.dismiss()

            guard let weakSelf = self else { return }
            weakSelf.orderedForecast = orderedForecast
            weakSelf.tableView.reloadData()
            weakSelf.tableView.isHidden = false
        }) { [weak self](error) in
            self?.showConnectionError()
        }
    }

    // MARK: - Methods

    private func forecastObjectFor(indexPath: IndexPath) -> ForecastForTime? {

        guard let dateForecastArray = forecastArrayFor(section: indexPath.section) else { return nil}
        let forecastObject = dateForecastArray[indexPath.row]
        return forecastObject
    }

    private func forecastArrayFor(section: Int) -> [ForecastForTime]? {

        guard let orderedForecastForTime = orderedForecast else { return nil }
        let sectionDate = orderedForecastForTime.timeArray[section]
        guard let dateForecastArray = orderedForecastForTime.forecastDictionary[sectionDate] else { return nil }
        return dateForecastArray
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
        requestWeatherForecastFor(coordinate: currentCoordinate)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherForecastViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        guard let currentCoordinate = locations.first?.coordinate else { return }
        requestWeatherForecastFor(coordinate: currentCoordinate)
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

// MARK: - UITableViewDataSource
extension WeatherForecastViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dateForecastArray = forecastArrayFor(section: section) else { return 0 }
        return dateForecastArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let forecastObject = forecastObjectFor(indexPath: indexPath) else { return UITableViewCell () }

        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier) as! WeatherForecastTableViewCell

        let time = Date().hourMinuteFromTimestamp(Double(forecastObject.date))
        let image = forecastObject.getCurrentWeatherImage()
        let weatherStatus = forecastObject.weatherStatus
        let temperature = "\(Int(forecastObject.temperature - 273.15))°"

        cell.set(time: time, image: image, weatherStatus: weatherStatus, temperature: temperature)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let orderedForecastForTime = orderedForecast else { return 1 }
        return orderedForecastForTime.timeArray.count
    }
}

// MARK: - UITableViewDelegate
extension WeatherForecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherForecastHeaderView.identifier) as! WeatherForecastHeaderView

        guard let orderedForecastForTime = orderedForecast else { return UIView() }
        let sectionDate = orderedForecastForTime.timeArray[section]
        headerView.setDateLabel(sectionDate.weekDay())

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(WeatherForecastHeaderView.suggestedHeight)
    }
}
