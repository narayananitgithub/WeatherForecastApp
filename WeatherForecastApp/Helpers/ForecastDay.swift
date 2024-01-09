//
//  ForecastDay.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 04/01/24.
//

import Foundation


struct LocationCoordinates {
    let latitude: Double
    let longitude: Double
}
// MARK: - ForecastDay
struct ForecastDay {
    var temperature: Double
    var windSpeed: Double
    var date: String
    var time: String
    var icon: String
    
    init(temperature: Double, windSpeed: Double, date: String, time: String, icon: String, additionalInfo2: String) {
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.date = date
        self.time = time
        self.icon = icon
    }
}
