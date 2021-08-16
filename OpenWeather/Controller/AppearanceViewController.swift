//
//  AppearanceViewController.swift
//  OpenWeather
//
//  Created by gunta.golde on 16/08/2021.
//

import UIKit

class AppearanceViewController: UIViewController {
    
    @IBOutlet weak var appearanceTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
    }
    
    @IBAction func openSettingsTapped(_ sender: Any) {
        openSettings()
    }
    
    func setLabelText(){
        var text = "Unable to specify UI style"
        if self.traitCollection.userInterfaceStyle == .dark{
            text = "Dark Mode is On.\nGo to Settings if you would like to change to\n Light Mode."
        }else{
            text = "Light Mode is On.\nGo to Settings if you would like to change to\n Dark Mode."
        }
        appearanceTextLabel.text = text
    }
    
    func openSettings(){
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingURL){
            UIApplication.shared.open(settingURL, options: [:]) { success in
                print("sucess: ", success)
            }
        }
    }
}

extension AppearanceViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setLabelText()
    }
}
