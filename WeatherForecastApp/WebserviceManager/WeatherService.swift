//
//  WeatherService.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 28/12/23.
//


import Alamofire
import Foundation



enum NetworkError: Error {
    case invalidResponse
   
}
// MARK: - WeatherServiceProtocol
protocol WeatherServiceProtocol {
    func getCurrentWeather(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void)
    func getWeatherForCustomLocation(_ location: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) 
    func getFiveDayForecast(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<ForcastModel, Error>) -> Void)
    func fetchWeatherForCustomLocation(city: String, completion: @escaping (Result<ForcastModel, Error>) -> Void)
    func getCoordinatesForLocation(_ location: String, completion: @escaping (LocationCoordinates?) -> Void)
   }
class WeatherService: WeatherServiceProtocol {
    // MARK: - Properties
    private let apiKey = WeatherURLs.apiKey
    private let baseUrl = WeatherURLs.baseUrl
    private let forecastUrl = WeatherURLs.forecastUrl
    // MARK: - getCurrentWeather
    func getCurrentWeather(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let parameters: [String: Any] = ["lat": latitude, "lon": longitude, "appid": apiKey, "units": "metric"]
        AF.request(baseUrl, parameters: parameters)
            .validate()
            .responseDecodable(of: WeatherModel.self) { response in
                print(response)
                switch response.result {
                case .success(let weatherData):
                    completion(.success(weatherData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func getWeatherForCustomLocation(_ location: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let parameters: [String: Any] = ["q": location, "appid": apiKey, "units": "metric"]
        AF.request(baseUrl, parameters: parameters)
            .validate()
            .responseDecodable(of: WeatherModel.self) { response in
                switch response.result {
                case .success(let weatherData):
                    completion(.success(weatherData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
   // MARK: - getFiveDayForecast
    func getFiveDayForecast(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<ForcastModel, Error>) -> Void) {
        let parameters: [String: Any] = ["lat": latitude, "lon": longitude, "appid": apiKey, "units": "metric"]
        AF.request(forecastUrl, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let forecastData = try decoder.decode(ForcastModel.self, from: data)
                            completion(.success(forecastData))
                            //                            print(forecastData)
                        } catch {
                            print("Error decoding response data: \(error)")
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "Response data is nil", code: 0, userInfo: nil)
                        print("Error: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Error in API request: \(error)")
                    completion(.failure(error))
                }
            }
    }
    // MARK: - fetchWeatherForCustomLocation
    func fetchWeatherForCustomLocation(city: String, completion: @escaping (Result<ForcastModel, Error>) -> Void) {
        let parameters: [String: Any] = ["q": city, "appid": apiKey, "units": "metric"]
        AF.request(forecastUrl, parameters: parameters)
            .validate()
            .responseDecodable(of: ForcastModel.self) { response in
                switch response.result {
                case .success(let forecastData):
                    completion(.success(forecastData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    // MARK: - getCoordinatesForLocation
    func getCoordinatesForLocation(_ location: String, completion: @escaping (LocationCoordinates?) -> Void) {
    }
}
