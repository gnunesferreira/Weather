//
//  WeatherForecastHeaderView.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/11/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit

class WeatherForecastHeaderView: UITableViewHeaderFooterView {

    static let suggestedHeight = 45
    static let identifier = "WeatherForecastHeaderViewIdentifier"

    @IBOutlet weak var dateLabel: UILabel!

    func setDateLabel(_ date: String) {
        dateLabel.text = date
    }
}
