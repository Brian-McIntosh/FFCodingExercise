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
}

class ViewController: UIViewController, MyViewControllerDelegate {
    
    private let viewModel = WeatherViewModel()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - UI
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - DATA
    var airports: [Airport]?
    var tempAirports = ["KPWM", "KAUS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setNeedsLayout()
        
        // MARK: - DELEGATES
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        do {
            self.airports = try context.fetch(Airport.fetchRequest())
        } catch {
            showAlert(message: "Catch error when fetching from Core Data")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            self.airports = try context.fetch(Airport.fetchRequest())
        } catch {
            showAlert(message: "Catch error when fetching from Core Data")
        }
        tableView.reloadData()
    }
    
    func receiveMsgFromViewModel(message: String) {
        showAlert(message: message)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        print("DATE: \(Date.now)")
        
        if searchTextField.text == "" || searchTextField.text == nil {
            showAlert(message: "Please enter an airport abbreviation.")
        } else {
            viewModel.getWeatherReport(forAirport: searchTextField.text!)
//            Task {
//                await getWeather(airport: searchTextField.text!)
//            }
//            searchTextField.resignFirstResponder()
        }
    }
    
    func navToDetailVC(response: Response) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.title = "Weather Conditions"
        vc.response = response
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    private func getWeather(airport: String) async {
//        print("VC func getWeather was passed airport: \(airport)")
//    }
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
            cell.detailTextLabel?.text = "Placeholder Date"
            
        }else{
            // Get airport from array and set the label
            let airport = self.airports![indexPath.row]
            cell.textLabel?.text = airport.abbreviation
            cell.detailTextLabel?.text = airport.creationDate
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
