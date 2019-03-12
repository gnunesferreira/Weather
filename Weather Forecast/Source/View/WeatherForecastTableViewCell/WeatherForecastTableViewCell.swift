//
//  WeatherForecastTableViewCell.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/11/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    static let identifier = "WeatherTableViewCellIdentifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(time: String, image: UIImage?, weatherStatus: String, temperature: String) {

        print("[WeatherForecastTableViewCell.set(time:image:weatherStatus:temperature] time: \(time) image: \(String(describing: image)) weatherStatus: \(weatherStatus) temperature: \(temperature)")

        descriptionImageView.image = image
        timeLabel.text = time
        statusLabel.text = weatherStatus
        temperatureLabel.text = temperature
    }
}
