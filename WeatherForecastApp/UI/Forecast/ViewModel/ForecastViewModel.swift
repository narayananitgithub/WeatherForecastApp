//
//  ForecastViewModel.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 31/12/23.
//

import Foundation



class ForecastViewModel {
    // MARK: - properties
    private let weatherService: WeatherServiceProtocol
    private var forecastModel: ForcastModel?
    var onDataUpdate: (() -> Void)?
// MARK: - init
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
 // MARK: - getFiveDayForecast
    func getFiveDayForecast(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<ForcastModel, Error>) -> Void) {

        weatherService.getFiveDayForecast(forLatitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let forecastData):
                self?.forecastModel = forecastData
                print(forecastData)
                self?.onDataUpdate?()
            case .failure(let error):
                print("Error fetching forecast data: \(error)")
            }
        }
    }
    // MARK: - getWeatherForCustomLocation
    func getWeatherForCustomLocation(_ location: String, completion: @escaping (WeatherInfo?) -> Void) {
        weatherService.fetchWeatherForCustomLocation(city: location) { result in
            switch result {
            case .success(let forecastModel):
                let weatherInfo = forecastModel.toWeatherInfo()
                completion(weatherInfo)
            case .failure(let error):
                print("Error fetching weather data: \(error)")
                completion(nil)
            }
        }
    }
    // MARK: - getForecastForLocation
    func getForecastForLocation(_ location: String, completion: @escaping (LocationCoordinates?) -> Void) {
        weatherService.getCoordinatesForLocation(location) { coordinates in
            completion(coordinates)
        }
    }

    func numberOfDays() -> Int {
       
        return min(forecastModel?.list?.count ?? 0, 5)
    }

    func forecastDay(at index: Int) -> ForecastDay? {
        guard let list = forecastModel?.list, index < list.count else {
            return nil
        }
        return list[index].toForecastDay(forDay: index)
    }
}
// MARK: - List
extension List {
    // MARK: - toForecastDay
    func toForecastDay(forDay index: Int) -> ForecastDay {
        var date = Date()
        let timestamp = TimeInterval(index * 24 * 60 * 60)
        date.addTimeInterval(timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm:ss"
        let formattedTime = dateFormatter.string(from: date)
        let weatherIcon: String
        if let firstWeather = weather?.first, let icon = firstWeather.icon {
            weatherIcon = icon
        } else {
            weatherIcon = "01n"
        }
        let additionalInfo2 = "Some additional info"
        
        return ForecastDay(
            temperature: main?.temp ?? 0.0,
            windSpeed: wind?.speed ?? 0.0,
            date: formattedDate,
            time: formattedTime,
            icon: weatherIcon,
            additionalInfo2: additionalInfo2
        )
    }
}
// MARK: - ForcastModel
extension ForcastModel {
    func toWeatherInfo() -> WeatherInfo {
        return WeatherInfo(
            temperature: Double(Int(list?.first?.main?.temp ?? 0.0)),
            humidity: Int(Double(list?.first?.main?.humidity ?? 0)),
            windSpeed: list?.first?.wind?.speed ?? 0.0
//            pressure: Double(list?.first?.main?.pressure ?? 0)
        )
    }
}
