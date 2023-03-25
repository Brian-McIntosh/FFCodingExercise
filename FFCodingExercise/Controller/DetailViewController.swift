//
//  DetailViewController.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/10/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - UI OUTLETS
    @IBOutlet weak var conditionsView: UIView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var foreCastView: UIView!
    @IBOutlet weak var forecastData: UILabel!
    
    // MARK: - PROPERTIES
    var response: Response?
    var conditions: CachedConditions?
    var airport: Airport?
    var isForecastShowing: Bool = false

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = airport?.abbreviation
        foreCastView.isHidden = true
        forecastData.text = "temp"
        
        // DetailVC airportAbbr: nil when view presented programmatically through viewModel as opposed to tableview
        //print("DetailVC airportAbbr: \(airportAbbr)")
        
        latitudeLabel.text = airport?.conditions?.lat.description
        longitudeLabel.text = airport?.conditions?.lon.description
        tempLabel.text = airport?.conditions?.tempC.description
        dewPointLabel.text = airport?.conditions?.dewpointC.description
        pressureLabel.text = airport?.conditions?.pressureHg.description
        
        forecastData.text = airport?.forecast?.dateIssued
    }
    
    @IBAction func toggleButtonPressed(_ sender: Any) {
        if isForecastShowing == false {
            conditionsView.isHidden = true
            foreCastView.isHidden = false
            isForecastShowing = true
        }else{
            conditionsView.isHidden = false
            foreCastView.isHidden = true
            isForecastShowing = false
        }
    }
    
}
