//
//  CachedForecast+CoreDataProperties.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/25/23.
//
//

import Foundation
import CoreData


extension CachedForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedForecast> {
        return NSFetchRequest<CachedForecast>(entityName: "CachedForecast")
    }

    @NSManaged public var dateIssued: String?
    @NSManaged public var airport: Airport?

}

extension CachedForecast : Identifiable {

}
