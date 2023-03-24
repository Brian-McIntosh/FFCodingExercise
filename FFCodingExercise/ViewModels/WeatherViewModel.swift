//
//  WeatherViewModel.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/11/23.
//

import Foundation
import UIKit
import CoreData

// TODO: Refactor to use WebService:
/*
     func populateWeather(url: URL) async {
         let weatherReport = try await Webservice().getWeather(url: url)
     }
 */

protocol WeatherViewModelDelegate {
    func sendMsgToView(message: String)
    func tellViewToShowDetail(response: Response)
    func tellViewToShowDetail(conditions: CachedConditions)
}
    
class WeatherViewModel: WeatherViewModelDelegate {
    
    var delegate: MyViewControllerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func sendMsgToView(message: String) {
        delegate?.receiveMsgFromViewModel(message: message)
    }
    
    func tellViewToShowDetail(response: Response) {
        delegate?.navToDetailVC(response: response)
    }
    
    func tellViewToShowDetail(conditions: CachedConditions) {
        delegate?.navToDetailVC(conditions: conditions)
    }
    
    func getWeatherReport(forAirport: String) {
        print("ViewModel: getWeatherReport(forAirport: \(forAirport))")
        
        // Create the FetchRequest to get all Airports
        let fetchRequest = NSFetchRequest<Airport>(entityName: "Airport")
        
        // Add a filter on the request to ONLY get objects where abbreviation matches what we passed in
        fetchRequest.predicate = NSPredicate(format: "abbreviation == %@", forAirport)
        
        do {
            // Run the fetch...
            let fetchedAirports = try context.fetch(fetchRequest)
            
            print("Found \(fetchedAirports.count) Airport(s) matching \(forAirport) in your local cache.")
            //-------------------------- should be 0 or 1

            guard fetchedAirports.count == 0 else {
                print("::: Oops, fetchedAirports.count does not equal 0!")
                print("::: meaning, we have something in Core Data")
                print("::: Note: you won't see any more Networking msgs after this due to return")
                
                 //Pass a Response? back to DetailViewController
                 DispatchQueue.main.async {
                     self.tellViewToShowDetail(conditions: fetchedAirports.first!.conditions!)
                 }
                 
//                print("::: Fetched Airport: \(fetchedAirports.first?.abbreviation)")
//                print("::: Fetched Airport: \(fetchedAirports.first?.creationDate)")
//                print("::: Fetched Airport: \(fetchedAirports.first?.conditions?.lat)")
//                print("::: Fetched Airport: \(fetchedAirports.first?.conditions?.lon)")
//                print("::: Fetched Airport: \(fetchedAirports.first?.conditions?.ident)")
                
                return
            }
            print(">>> Our guard statement let us pass through!")
        } catch {
            print("Fetch failed")
        }
        
        let searchString = APIConstants.baseUrl + forAirport
        let searchUrl = URL(string: searchString)!
        var request = URLRequest(url: searchUrl)
        request.setValue("1", forHTTPHeaderField: "ff-coding-exercise")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.sendMsgToView(message: "Does not seem to be a valid airport.")
                    print("Does not seem to be a valid airport.")
                }
                return
            }
            
            print("This is after 1st guard statement - meaning 200 httpResponse")
            
            if let error = error {
                
                // Handle HTTP request error
                // print(error)
                DispatchQueue.main.async {
                    self.sendMsgToView(message: "Error: \(error.localizedDescription)")
                }
                
            } else if let data = data {
                
                // Handle HTTP request response
                // print(data)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let response: Response = try! decoder.decode(Response.self, from: data)
//                print(response.report.conditions.ident)
//                print(response.report.conditions.dateIssued)
//                print(response.report.conditions.elevationFt)
                
                guard response.report.conditions != nil else {
                    DispatchQueue.main.async {
                        self.sendMsgToView(message: "Response does not contain conditions")
                        print("Response does not contain conditions")
                    }
                    return
                }
                
                print("This is after 2nd guard statement - meaning Conditions is not nil")
                
                
                // All this does is save TTT to Core Data
                self.saveAirportToCoreData(airportAbbreviation: forAirport, response: response)
                // we need something like: updateCache(with: decodedResponse)
                // ^^ can't we combine them? -- we have Airport Abbreviation and Airport Response
                // save Airport to Core Data with Airport text
                // updateCache with Response object
                
                
                // This passes response object to DetailViewController
//                DispatchQueue.main.async {
//                    self.tellViewToShowDetail(response: response)
//                }
                
            } else {
                DispatchQueue.main.async {
                    self.sendMsgToView(message: "Unknown error.")
                }
            }
        }
        task.resume()
    }
    
    func saveAirportToCoreData(airportAbbreviation: String, response: Response) {
        print("Try saving to Core Data: \(airportAbbreviation)")
        
        var newAirport = Airport(context: self.context)
        newAirport.abbreviation = airportAbbreviation
        newAirport.creationDate = "some date"
        
        var newConditions = CachedConditions(context: self.context)
        newConditions.ident = response.report.conditions?.ident
        newConditions.lat = response.report.conditions?.lat ?? 0.0
        newConditions.lon = response.report.conditions?.lon ?? 0.0
        newConditions.tempC = response.report.conditions?.tempC ?? 0.0
        newConditions.dewpointC = response.report.conditions?.dewpointC ?? 0.0
        newConditions.pressureHg = response.report.conditions?.pressureHg ?? 0.0
        
        //newConditions.airport = newAirport <-- seems not to work :(
        newAirport.conditions = newConditions //<-- seems to work :)
        
        DispatchQueue.main.async {
            self.tellViewToShowDetail(conditions: newConditions)
        }
        
        // TODO: SAVE SOME FORECAST DATA SO YOU CAN TRY SWITCHING VIEWS
        

        // Save to Core Data
        do {
            try self.context.save()
            print("Success saving \(airportAbbreviation) to Core Data")
        }
        catch {
            print("Error in saving \(airportAbbreviation) to Core Data")
        }
    }
    
    // FROM SWIFTUI PROJECT:
//    func updateCache(with decodedResponse: Response) {
//
//    }
}
