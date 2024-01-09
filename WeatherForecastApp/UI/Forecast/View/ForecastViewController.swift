//
//  ForecastViewController.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 31/12/23.
//

import UIKit
import CoreLocation


class ForecastViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK:  - @IBOutlets
    @IBOutlet weak var forecasttempLabel: UILabel!
    @IBOutlet weak var forecastHtyLbl: UILabel!
    @IBOutlet weak var forecastwindLbl: UILabel!
    @IBOutlet weak var forecastImg: UIImageView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTxt: UITextField!
    // MARK: - properties
    private var viewModel: ForecastViewModel!
    let weatherService = WeatherService()
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTxt.delegate = self
        searchTxt.clearButtonMode = .whileEditing
        setupCollectionView()
        setupActivityIndicator()
        
        viewModel = ForecastViewModel(weatherService: WeatherService())
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.stopLoading()
            }
        }
        startLoading()
        viewModel.getFiveDayForecast(forLatitude: 37.7749, longitude: -122.4194) { [weak self] result in
            switch result {
            case .success(let forecastData):
                // Handle successful forecast data
                print("Forecast data: \(forecastData)")
            case .failure(let error):
                // Handle failure, print or log the error
                print("Error fetching forecast data: \(error)")
                // Stop loading in case of an error
                self?.stopLoading()
            }
            self?.stopLoadingAfterDelay()
        }
    }
    
   // MARK: - @IBAction
    
    @IBAction func onClickSearchForecastBtn(_ sender: UIButton) {
            guard let customLocation = searchTxt.text else {
                return
            }
            startLoading()
            viewModel.getWeatherForCustomLocation(customLocation) { [weak self] weatherInfo in
                if let weatherInfo = weatherInfo {
                    print(weatherInfo)
                    self?.updateUI(with: weatherInfo)
                } else {
                    // Handle the case where weather data is not available
                    print("Weather data not available.")
                }
                self?.stopLoadingAfterDelay()
            }
        }
    // MARK: - updateUI
    private func updateUI(with weatherInfo: WeatherInfo) {
        let roundedTemperature = Int(round(weatherInfo.temperature))
        forecasttempLabel.text = "\(roundedTemperature)°C"
        forecastHtyLbl.text = "\(weatherInfo.humidity)%"
        forecastwindLbl.text = "\(weatherInfo.windSpeed)m/s"
        
        let weatherIcon = self.weatherIcon(forTemperature: Double(weatherInfo.temperature)) ?? "weatherIcon_default"
        print("Weather Icon Name: \(weatherIcon)")
        self.forecastImg.image = UIImage(systemName: weatherIcon)
    }
// MARK: - weatherIcon
    func weatherIcon(forTemperature temperature: Double) -> String {
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
// MARK: - startLoading
    private func startLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
// MARK: - stopLoading
    private func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    // MARK: - setupActivityIndicator
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
// MARK: - stopLoadingAfterDelay
    private func stopLoadingAfterDelay() {
        // Stop loading indicator after a delay (e.g., 2 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.stopLoading()
        }
    }
// MARK: - setupCollectionView
       private func setupCollectionView() {
           collectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ForecastCollectionViewCell")

           collectionView.dataSource = self
           collectionView.delegate = self
       }
   }
// MARK: - UICollectionViewDataSource
extension ForecastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDays()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let forecastDay = viewModel.forecastDay(at: indexPath.row) {
            cell.configure(with: forecastDay, at: indexPath)
        }
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
   extension ForecastViewController: UICollectionViewDelegateFlowLayout {
       // MARK: - sizeForItemAt
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 200, height: 310)
       }
   }
// MARK: - UITextFieldDelegate
extension ForecastViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxt.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
}















