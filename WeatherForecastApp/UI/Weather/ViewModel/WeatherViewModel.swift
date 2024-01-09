//
//  WeatherViewModel.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 28/12/23.
//

import Foundation



class CurrentWeatherViewModel {
    // MARK: - Properties
    private let weatherService: WeatherServiceProtocol
    private(set) var currentWeather: WeatherModel?
    // MARK: - init
       init(weatherService: WeatherServiceProtocol) {
           self.weatherService = weatherService
       }
       // MARK: - fetchCurrentWeather
       func fetchCurrentWeather(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
           weatherService.getCurrentWeather(forLatitude: latitude, longitude: longitude) { result in
               print(result)
               switch result {
               case .success(let weatherData):
                   self.currentWeather = weatherData
                   completion(.success(weatherData))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    // MARK: - fetchWeatherForCustomLocation
    func fetchWeatherForCustomLocation(_ location: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        weatherService.getWeatherForCustomLocation(location) { result in
            switch result {
            case .success(let weather):
                self.currentWeather = weather
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
