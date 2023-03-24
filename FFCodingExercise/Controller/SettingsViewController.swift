//
//  SettingsViewController.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/22/23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedSliderValue = defaults.integer(forKey: "SliderValue")
        print("Saved slider value: \(savedSliderValue)")
        slider.value = Float(savedSliderValue)
        label.text = "\(Int(savedSliderValue)) min"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let savedSliderValue = defaults.integer(forKey: "SliderValue")
        print("Saved slider value: \(savedSliderValue)")
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        label.text = "\(Int(slider.value)) min"
        defaults.set(slider.value, forKey: "SliderValue")
    }
}
