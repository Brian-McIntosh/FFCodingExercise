//
//  Webservice.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/11/23.
//

import Foundation

class Webservice {
    
    func getWeather(url: URL) async throws -> Report {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            fatalError("HTTP Response is NOT 200!")
        }
        
        return try JSONDecoder().decode(Report.self, from: data)
        
    }
    
}
