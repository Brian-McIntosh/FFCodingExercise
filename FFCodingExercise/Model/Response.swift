//
//  Response.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/10/23.
//

import Foundation

struct Response: Codable {
    let report: Report
}

struct Report: Codable {
    let conditions: Conditions?
    let forecast: Forecast
}

struct Forecast: Codable {
    let dateIssued: String
}

struct Conditions: Codable {
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
