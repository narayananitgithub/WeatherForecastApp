//
//  WeatherData.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 28/12/23.
//

import Foundation
// MARK: - WeatherModel
struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    enum CodingKeys: String, CodingKey {
        case coord, weather, base, main, visibility, wind, clouds, dt, sys, timezone, id, name, cod
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
        clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
        dt = try values.decodeIfPresent(Int.self, forKey: .dt)
        sys = try values.decodeIfPresent(Sys.self, forKey: .sys)
        timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        cod = try values.decodeIfPresent(Int.self, forKey: .cod)
    }
}
// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
    enum CodingKeys: String, CodingKey {
        case all
    }
}
// MARK: - Coord
struct Coord: Codable {
    let lon: Double?
    let lat: Double?
    enum CodingKeys: String, CodingKey {
        case lon, lat
    }
}
// MARK: - Main
struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    enum CodingKeys: String, CodingKey {
        case temp, feelsLike, tempMin, tempMax, pressure, humidity, seaLevel, grndLevel
    }
}
// MARK: - Sys
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
    enum CodingKeys: String, CodingKey {
        case type, id, country, sunrise, sunset
    }
}
// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    enum CodingKeys: String, CodingKey {
        case id, main, description, icon
    }
}
// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?

    enum CodingKeys: String, CodingKey {
        case speed, deg, gust
    }
}
