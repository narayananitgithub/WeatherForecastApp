//
//  SearchViewController.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 31/12/23.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchbar: UITextField!
    @IBOutlet weak var displayImgView: UIImageView!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.cornerRadius = 12
            backgroundView.layer.masksToBounds = true
        }
    }
    // MARK: - properties
    let weatherService = WeatherService()
    private var loadingIndicator: UIActivityIndicatorView?
    private var overlayView: UIView?
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        searchbar.clearButtonMode = .whileEditing
    }
    // MARK: - onClicksearchBtn
    @IBAction func onClicksearchBtn(_ sender: UIButton) {
        guard let location = searchbar.text, !location.isEmpty else {
            return
        }
        showLoadingView()
        weatherService.getWeatherForCustomLocation(location) { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.hideLoadingView()
                
                switch result {
                case .success(let weatherData):
                    DispatchQueue.main.async { [weak self] in
                        self?.updateLabels(with: weatherData)
                        let temperature = weatherData.main?.temp
                        print("\(temperature ?? 0.0)")
                        let weatherIconName = self?.weatherIconName(forTemperature: temperature ?? 0.0) ?? "weatherIcon_default"
                        print("Weather Icon Name: \(weatherIconName)")
                        self?.weatherIconImage.image = UIImage(systemName:weatherIconName)
                    }
                case .failure(let error):
                    print("Error fetching weather: \(error.localizedDescription)")
                }
            }
        }
    }
    // MARK: - weatherIconName
    func weatherIconName(forTemperature temperature: Double) -> String {
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
    
    private func showLoadingView() {
        overlayView = UIView(frame: view.bounds)
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(overlayView!)
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = view.center
        view.addSubview(loadingIndicator!)
        
        loadingIndicator?.startAnimating()
    }
    // MARK: - hideLoadingView
    private func hideLoadingView() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        overlayView?.removeFromSuperview()
    }
    // MARK: - updateLabels
    func updateLabels(with weatherData: WeatherModel) {
        if let temperature = weatherData.main?.temp {
            let formattedTemperature = String(format: "%.0f", temperature)
            tempLbl.text = "\(formattedTemperature)°C"
        } else {
            tempLbl.text = "N/A"
        }
        
        if let windSpeed = weatherData.wind?.speed {
            windLabel.text = "Wind: \(windSpeed) m/s"
        } else {
            windLabel.text = "Wind: N/A"
        }
        if let humidity = weatherData.main?.humidity {
            humidityLabel.text = "Humidity: \(humidity)%"
        } else {
            humidityLabel.text = "Humidity: N/A"
        }
        
        if let pressure = weatherData.main?.pressure {
            pressureLabel.text = "Pressure: \(pressure) hPa"
        } else {
            pressureLabel.text = "Pressure: N/A"
        }
        
        if let weatherDescription = weatherData.weather?.first?.description {
            descriptionLabel.text = "Description: \(weatherDescription)"
        } else {
            descriptionLabel.text = "Description: N/A"
        }
    }
}
// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchbar.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
}
