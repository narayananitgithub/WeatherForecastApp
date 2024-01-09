//
//  ForecastCollectionViewCell.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 07/01/24.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var mondayLbl: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var baseView: UIView!{
        didSet{
            self.baseView.layer.cornerRadius = 12
            self.baseView.layer.masksToBounds = true
        }
    }
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // MARK: - configure
    func configure(with forecastDay: ForecastDay, at indexPath: IndexPath) {
        temperatureLabel.text = "\(forecastDay.temperature)°C"
        windLabel.text = "Wind: \(forecastDay.windSpeed) m/s"
        dateLabel.text = forecastDay.date
        timeLbl.text = "Time: \(forecastDay.time)"
        let forecast = self.forecastIcon(forTemperature: forecastDay.temperature) ?? "weatherIcon_default"
        print("Weather Icon Name: \(forecast)")
        weatherIconImageView.image = UIImage(systemName: forecast)
        
        let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        if indexPath.section == 0 {
            let currentIndex = indexPath.item
            if currentIndex < daysOfWeek.count {
                let dayOfWeek = daysOfWeek[currentIndex]
                mondayLbl.text = dayOfWeek
            } else {
                mondayLbl.text = "Unknown"
            }
        } else {
            mondayLbl.text = ""
        }
    }
    
    // MARK: - forecastIcon
    func forecastIcon(forTemperature temperature: Double) -> String {
        if temperature > 30 {
            return "sun.max"
        } else if temperature > 25 {
            return "sun.max"
        } else if temperature > 20 {
            return "cloud.sun"
        } else if temperature > 15 {
            return "cloud.sun.fill"
        } else if temperature > 10 {
            return "cloud"
        } else {
            return "cloud.rain"
        }
    }
    
}
        
       
