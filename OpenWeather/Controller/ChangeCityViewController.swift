//
//  ChangeCityViewController.swift
//  OpenWeather
//
//  Created by gunta.golde on 14/08/2021.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnterCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegte: ChangeCityDelegate?
    
    @IBOutlet weak var cityTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getWeatherTapped(_ sender: Any) {
        guard let cityName = cityTextField.text else {return}
        
        if !cityName.isEmpty {
            delegte?.userEnterCityName(city: cityName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
