//
//  ViewController.swift
//  OpenWeather
//
//  Created by gunta.golde on 13/08/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let weatherDataModel = WeatherDataModel()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func infoBarItem(_ sender: Any) {
        
        basicAlert(title: "Current Weather Info", message: "Press cloud button to open tab where you can enter the city name and get current weather")
    }
    
    
    //MARK: - CLLocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            print("Long: \(location.coordinate.longitude), lat: \(location.coordinate.latitude)")
            
            let long = String(location.coordinate.longitude)
            let lat = String(location.coordinate.latitude)
            
            let params: [String: String] = ["lat" : lat, "lon" : long, "appid" : weatherDataModel.apiId]
            getWeatherData(url: weatherDataModel.apiUrl, params: params)
            
        }
    }
    
    func getWeatherData(url: String, params: [String: String]){
        AF.request(url, method: .get, parameters: params).responseJSON { [self] response in
            if response.value != nil {
                let weatherJSON: JSON = JSON(response.value!)
              //  print("weatherJSON: ", weatherJSON)
                updateWeatherData(json: weatherJSON)
            }else{
                self.cityLabel.text = "weather unavailable ☹️"
            }
        }
    }
    
    func updateWeatherData(json: JSON){
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temp = Int(tempResult - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUI()
        }else{
            self.cityLabel.text = "weather unavailable ☹️"
        }
    }
    
    func updateUI(){
        cityLabel.text = weatherDataModel.city
        tempLabel.text = "\(weatherDataModel.temp)º"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    func userEnterCityName(city: String) {
        print(city)
        let params: [String: String] = ["q": city, "appId" : weatherDataModel.apiId]
        getWeatherData(url: weatherDataModel.apiUrl, params: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city"{
            let vc = segue.destination as! ChangeCityViewController
            vc.delegte = self
        }
    }
    
}
