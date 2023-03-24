//
//  ViewController.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/10/23.
//

import UIKit
import CoreData

protocol MyViewControllerDelegate {
    func receiveMsgFromViewModel(message: String)
    func navToDetailVC(response: Response)
    func navToDetailVC(conditions: CachedConditions)
}

class ViewController: UIViewController, MyViewControllerDelegate {
    
    // MARK: - DATA for Display
    var airports: [Airport]?
    var tempAirports = ["KPWM", "KAUS"]
    
    // MARK: - PROPERTIES
    private let viewModel = WeatherViewModel()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - IBOUTLETS & ACTIONS
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchTextField.text == "" || searchTextField.text == nil {
            showAlert(message: "Please enter an airport abbreviation.")
        } else {
            viewModel.getWeatherReport(forAirport: searchTextField.text!)
        }
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setNeedsLayout()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        // MARK: - DELEGATES
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        
        do {
            self.airports = try context.fetch(Airport.fetchRequest())
        } catch {
            showAlert(message: "Error in ViewController when trying to fetch Airport entities from Core Data.")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        do {
            self.airports = try context.fetch(Airport.fetchRequest())
        } catch {
            showAlert(message: "Error in ViewController when trying to fetch Airport entities from Core Data.")
        }
        tableView.reloadData()
    }
    
    // MARK: - ALERT HANDLING
    func receiveMsgFromViewModel(message: String) {
        showAlert(message: message)
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - NAVIGATION
    func navToDetailVC(response: Response) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.title = "Weather Conditions"
        vc.response = response
        navigationController?.pushViewController(vc, animated: true)
    }
    func navToDetailVC(conditions: CachedConditions) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.title = "Weather Conditions"
        vc.conditions = conditions
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - EXTENSIONS
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.airports?.count == 0 {
            return tempAirports.count
        }else{
            return self.airports!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if self.airports?.count == 0 {
            
            cell.textLabel?.text = tempAirports[indexPath.row]
            cell.detailTextLabel?.text = Date.now.description
            
        }else{

            let airport = self.airports![indexPath.row]
            cell.textLabel?.text = airport.abbreviation
            cell.detailTextLabel?.text = airport.creationDate?.description
        }
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: 24)
                
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        //let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        if self.airports?.count == 0 {
            //vc.airportAbbr = tempAirports[indexPath.row]
            viewModel.getWeatherReport(forAirport: tempAirports[indexPath.row])
        }else{
            let airport = self.airports![indexPath.row]
            //vc.airportAbbr = airport.abbreviation
            viewModel.getWeatherReport(forAirport: airport.abbreviation!)
        }
        
        //navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
