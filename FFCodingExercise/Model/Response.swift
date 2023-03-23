//
//  Response.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/10/23.
//

import Foundation

struct Response: Decodable {
    let report: Report
}

struct Report: Decodable {
    let conditions: Conditions?
    //let forecast: Forecast
}

//struct Forecast: Decodable {
//    
//}

struct Conditions: Decodable {
    //let text, ident: String?
    //let dateIssued: Date?
    let lat, lon: Double?
    let tempC, dewpointC: Int?
    let pressureHg: Double?
    //let elevationFt, tempC, dewpointC: Int?
    //let pressureHg, pressureHpa: Double?
    //let reportedAsHpa: Bool?
    //let densityAltitudeFt, relativeHumidity: Int?
}

//struct Conditions: Decodable {
//    let ident: String
//    let dateIssued: String
//    let elevationFt: Double
//    //let tempC: Int
//    //let dewpointC: Int
//}
