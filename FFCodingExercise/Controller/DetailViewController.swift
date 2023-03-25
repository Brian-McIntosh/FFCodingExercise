//
//  DetailViewController.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/10/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - UI OUTLETS
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var foreCastView: UIView!
    
    // MARK: - PROPERTIES
    var response: Response?
    var conditions: CachedConditions?
    var isForecastShowing: Bool = false

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        foreCastView.isHidden = true
        // DetailVC airportAbbr: nil when view presented programmatically through viewModel as opposed to tableview
        //print("DetailVC airportAbbr: \(airportAbbr)")
        
        
        
        latitudeLabel.text = conditions?.lat.description
        longitudeLabel.text = conditions?.lon.description
        tempLabel.text = conditions?.tempC.description
        dewPointLabel.text = conditions?.dewpointC.description
        pressureLabel.text = conditions?.pressureHg.description
    }
    
    @IBAction func toggleButtonPressed(_ sender: Any) {
        if isForecastShowing == false {
            foreCastView.isHidden = false
            isForecastShowing = true
        }else{
            foreCastView.isHidden = true
            isForecastShowing = false
        }
    }
    
}
