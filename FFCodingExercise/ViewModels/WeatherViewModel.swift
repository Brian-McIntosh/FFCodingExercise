//
//  WeatherViewModel.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/11/23.
//

import Foundation
import UIKit

protocol WeatherViewModelDelegate {
    func sendMsgToView(message: String)
    func tellViewToShowDetail(response: Response)
}

class WeatherViewModel: WeatherViewModelDelegate {
    
    var delegate: MyViewControllerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveAirportToCoreData(textToSave: String) {
        print("Try saving to Core Data: \(textToSave)")
        
        // Create a new Airport object - Airport is a subclass of NSManagedObject which allows us to save to Core Data
        let newAirport = Airport(context: self.context)
        newAirport.abbreviation = textToSave
        
        // Save to Core Data
        do {
            try self.context.save()
            print("Success saving \(textToSave) to Core Data")
        }
        catch {
            print("Error in saving to Core Data")
            //sendMsgToView(message: "Error in saving to Core Data")
        }
    }
    
    func sendMsgToView(message: String) {
        delegate?.receiveMsgFromViewModel(message: message)
    }
    
    func tellViewToShowDetail(response: Response) {
        delegate?.navToDetailVC(response: response)
    }

    func getWeatherReport(forAirport: String) {
        print("ViewModel: getWeatherReport(forAirport: \(forAirport))")
        
        let searchString = APIConstants.baseUrl + forAirport
        let searchUrl = URL(string: searchString)!
        var request = URLRequest(url: searchUrl)
        request.setValue("1", forHTTPHeaderField: "ff-coding-exercise")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.sendMsgToView(message: "Does not seem to be a valid airport.")
                }
                return
            }
            
            print("This is after the guard statement - meaning 200 httpResponse")
            
            self.saveAirportToCoreData(textToSave: forAirport)

            if let error = error {
                
                // Handle HTTP request error
                // print(error)
                DispatchQueue.main.async {
                    self.sendMsgToView(message: "Error: \(error.localizedDescription)")
                }
                
            } else if let data = data {
                
                // Handle HTTP request response
                // print(data)
                let response: Response = try! JSONDecoder().decode(Response.self, from: data)
//                print(response.report.conditions.ident)
//                print(response.report.conditions.dateIssued)
//                print(response.report.conditions.elevationFt)
                
                DispatchQueue.main.async {
                    self.tellViewToShowDetail(response: response)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.sendMsgToView(message: "Unknown error.")
                }
            }
        }
        task.resume()
    }
    
    func populateWeather(url: URL) async {
        
    }
    
//    func populateWeather(url: URL) async {
//        do {
//            let weatherReport = try await Webservice().getWeather(url: url)
//        }catch{
//            print(error)
//        }
//    }
}
