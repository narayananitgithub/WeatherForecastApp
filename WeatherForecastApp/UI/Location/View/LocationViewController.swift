//
//  LocationViewController.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 29/12/23.
//

import UIKit

class LocationViewController: UIViewController {
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var locationTableview:
    UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
//class CurrentWeatherViewController: UIViewController {
//
//    @IBOutlet weak var dataTableView: UITableView!
//
//    var viewModel = CurrentWeatherViewModel()
//    let locationManager = CLLocationManager()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.dataTableView.dataSource = self
//        self.dataTableView.delegate = self
//        self.registerCells()
//        self.setupLocation()
//    }
//
//    fileprivate func registerCells() {
//        let nib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
//        dataTableView.register(nib, forCellReuseIdentifier: "WeatherTableViewCell")
//    }
//
//    func setupLocation() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func fetchCurrentWeatherData(latitude: Double, longitude: Double) {
//        viewModel.fetchCurrentWeather(forLatitude: latitude, longitude: longitude) { result in
//            switch result {
//            case .success(let currentWeather):
//                self.updateUI(with: currentWeather)
//            case .failure(let error):
//                print("Error fetching current weather: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func updateUI(with weather: WeatherModel) {
//        DispatchQueue.main.async {
//            self.dataTableView.reloadData()
//        }
//    }
//}
//
//extension CurrentWeatherViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1 // Display only one row for current weather
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else {
//            return UITableViewCell()
//        }
//
//        if let currentWeather = viewModel.currentWeather {
//            cell.temperatureLabel.text = "\(currentWeather.main?.temp ?? 0)°C"
//            cell.weatherDescriptionLabel.text = currentWeather.weather?.first?.description
//            cell.locationLabel.text = currentWeather.name
//            cell.displyImg.image = UIImage(named: "Weather")
//            // Set the image for displayImg as needed
//        }
//
//        return cell
//    }
//}
//
//extension CurrentWeatherViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 240
//    }
//}
//
//// MARK: - CLLocationManagerDelegate
//extension CurrentWeatherViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        manager.stopUpdatingLocation()
//        if let location = locations.last {
//            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
//            
//            // Update your weather data with the current location
//            fetchCurrentWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error: \(error.localizedDescription)")
//    }
//}
