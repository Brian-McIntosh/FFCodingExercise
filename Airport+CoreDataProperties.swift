//
//  Airport+CoreDataProperties.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/23/23.
//
//

import Foundation
import CoreData


extension Airport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airport> {
        return NSFetchRequest<Airport>(entityName: "Airport")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var creationDate: String?
    @NSManaged public var conditions: CachedConditions?

}

extension Airport : Identifiable {

}
