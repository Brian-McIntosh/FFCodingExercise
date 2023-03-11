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
    let conditions: Conditions
}

struct Conditions: Codable {
    let ident: String
    //let elevationFt: Int
    //let tempC: Int
    //let dewpointC: Int
}
