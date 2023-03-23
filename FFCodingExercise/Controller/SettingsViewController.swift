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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        label.text = "\(Int(slider.value)) min"
    }
    
    

}
