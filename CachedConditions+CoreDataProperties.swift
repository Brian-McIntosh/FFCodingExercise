//
//  CachedConditions+CoreDataProperties.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/25/23.
//
//

import Foundation
import CoreData


extension CachedConditions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedConditions> {
        return NSFetchRequest<CachedConditions>(entityName: "CachedConditions")
    }

    @NSManaged public var dewpointC: Double
    @NSManaged public var ident: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var pressureHg: Double
    @NSManaged public var tempC: Double
    @NSManaged public var airport: Airport?

}

extension CachedConditions : Identifiable {

}
