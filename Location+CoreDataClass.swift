//
//  Location+CoreDataClass.swift
//  My Locations
//
//  Created by demas on 25/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

public class Location: NSManagedObject, MKAnnotation {

    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    public var title: String? {
        if locationDescription.isEmpty {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    
    public var subtitle: String? {
        return category
    }
}
