//
//  WeatherViewController.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 28/12/23.
//

import UIKit
import CoreLocation


class CurrentWeatherViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var currentImgView: UIImageView!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.cornerRadius = 12
            backgroundView.layer.masksToBounds = true
        }
    }
    // MARK: - circularView
    @IBOutlet weak var circularView: CircularView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap1))
            circularView.addGestureRecognizer(tapGesture)
        }
    }
    var viewModel = CurrentWeatherViewModel(weatherService: WeatherService() as! WeatherServiceProtocol)
    var locationManager = CLLocationManager()
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        observeAuthorizationChanges()
    }
    // MARK: - observeAuthorizationChanges
    func observeAuthorizationChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(authorizationStatusChanged), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    // MARK: - authorizationStatusChanged
    @objc func authorizationStatusChanged() {
        // Check the current authorization status
        let status = CLLocationManager.authorizationStatus()
        
        DispatchQueue.main.async { [weak self] in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self?.circularView.tintColor = UIColor.blue
            default:
                self?.circularView.tintColor = UIColor.gray
            }
        }
    }
    // MARK: - handleTap1
    @objc func handleTap1() {
        self.circularView.tintColor = UIColor.blue
        
        setupLocationManager()
        checkLocationAuthorization { authorized in
            if authorized {
                DispatchQueue.global().async { [weak self] in
                    self?.getLocationAndUpdateWeather()
                    DispatchQueue.main.async {
                        self?.circularView.tintColor = UIColor.blue
                        self?.locationImg.tintColor = UIColor.blue
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.circularView.tintColor = UIColor.gray
                    self.locationImg.tintColor = UIColor.gray
                }
            }
        }
    }
    // MARK: - getLocationAndUpdateWeather
    func getLocationAndUpdateWeather() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled.")
            return
        }
        guard let location = locationManager.location else {
            print("Location not available yet. Waiting for updates...")
            return
        }
        guard location.coordinate.latitude != 0.0 && location.coordinate.longitude != 0.0 else {
            print("Invalid coordinates. Waiting for valid location updates...")
            return
        }
        print(location.coordinate.latitude, location.coordinate.longitude)
        
        viewModel.fetchCurrentWeather(forLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] result in
            switch result {
            case .success(let weather):
                print("Weather fetched successfully: \(weather)")
                DispatchQueue.main.async {
                    self?.updateUI(with: weather)
                }
            case .failure(let error):
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    // MARK: - setupLocationManager
    func setupLocationManager() {
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    // MARK: - updateUI
    func updateUI(with weather: WeatherModel) {
        guard let temperature = weather.main?.temp else {
            print("Temperature data not available.")
            tempLbl.text = "N/A"
            return
        }
        let roundedTemperature = round(temperature)
        tempLbl.text = "\(Int(roundedTemperature))°C"
        humidityLbl.text = "Humidity: \(weather.main?.humidity ?? 0)%"
        windLbl.text = "Wind: \(weather.wind?.speed ?? 0) m/s"
        pressureLbl.text = "Pressure: \(weather.main?.pressure ?? 0) hPa"
        descriptionLbl.text = weather.weather?.first?.description ?? "No Description"
        let weatherIcon = currentWeatherIcon(forTemperature: temperature)
        print("Weather Icon Name: \(weatherIcon)")
        self.currentImgView.image = UIImage(systemName: weatherIcon)
    }
    // MARK: - currentWeatherIcon
    func currentWeatherIcon(forTemperature temperature: Double) -> String {
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
    // MARK: - showLocationDeniedAlert
    func showLocationDeniedAlert() {
    }
    // MARK: - locationManagerDidChangeAuthorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.global().async { [weak self] in
                self?.getLocationAndUpdateWeather()
            }
            
        case .denied, .restricted:
            showLocationDeniedAlert()
        case .notDetermined:
            DispatchQueue.global().async { [weak self] in
                self?.locationManager.requestWhenInUseAuthorization()
            }
        @unknown default:
            break
        }
    }
}
// MARK: - CLLocationManagerDelegate
extension CurrentWeatherViewController: CLLocationManagerDelegate{
    // MARK: - didChangeAuthorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            DispatchQueue.global().async { [weak self] in
                self?.getLocationAndUpdateWeather()
            }
        } else {
            showLocationDeniedAlert()
        }
    }
    // MARK: - didFailWithError
    func locationManager(manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    // MARK: - checkLocationAuthorization
    func checkLocationAuthorization(completion: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            completion(true)
        case .denied, .restricted:
            showLocationDeniedAlert()
            completion(false)
        case .notDetermined:
            DispatchQueue.global().async { [weak self] in
                self?.locationManager.requestWhenInUseAuthorization()
                completion(false)
            }
        @unknown default:
            completion(false)
        }
    }
}

