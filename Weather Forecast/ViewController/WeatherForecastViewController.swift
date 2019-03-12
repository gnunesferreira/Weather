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

    @IBOutlet weak var tableView: UITableView!

    private let locationManager = CLLocationManager()
    private var orderedForecast: OrderedForecastForTime?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WeatherForecastTableViewCell", bundle: nil), forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        tableView.register(UINib(nibName: "WeatherForecastHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: WeatherForecastHeaderView.identifier)

        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    private func requestWeatherForecastFor(coordinate: CLLocationCoordinate2D) {

        let location = CLLocationCoordinate2D(latitude: 50.072757, longitude: 14.4346233)

        WeatherManager.getWeatherForecast(location: location, success: { [weak self](orderedForecast) in

            guard let weakSelf = self else { return }
            weakSelf.orderedForecast = orderedForecast
            weakSelf.tableView.reloadData()
        }) { (error) in

        }
    }
}

extension WeatherForecastViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        guard let currentCoordinate = locations.first?.coordinate else { return }
        requestWeatherForecastFor(coordinate: currentCoordinate)
    }
}

extension WeatherForecastViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let orderedForecastForTime = orderedForecast else { return 0 }
        let sectionDate = orderedForecastForTime.timeArray[section]
        guard let dateForecastArray = orderedForecastForTime.forecastDictionary[sectionDate] else { return 0 }
        return dateForecastArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let orderedForecastForTime = orderedForecast else { return UITableViewCell() }
        let sectionDate = orderedForecastForTime.timeArray[indexPath.section]
        guard let dateForecastArray = orderedForecastForTime.forecastDictionary[sectionDate] else { return UITableViewCell() }
        let forecastObject = dateForecastArray[indexPath.row]

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
