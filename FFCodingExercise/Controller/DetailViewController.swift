//
//  DetailViewController.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/10/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    //var airportAbbr: String?
    var response: Response?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DetailVC airportAbbr: nil when view presented programmatically through viewModel as opposed to tableview
        //print("DetailVC airportAbbr: \(airportAbbr)")
        
        latitudeLabel.text = response?.report.conditions.lat?.description
        longitudeLabel.text = response?.report.conditions.lon?.description
        tempLabel.text = response?.report.conditions.tempC?.description
        dewPointLabel.text = response?.report.conditions.dewpointC?.description
        pressureLabel.text = response?.report.conditions.pressureHg?.description
    }
}
