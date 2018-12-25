//
//  PinAnnotation.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    let student: String
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let url: String
    
    init(student: String, locationName: String, coordinate: CLLocationCoordinate2D, url: String) {
        self.student = student
        self.locationName = locationName
        self.coordinate = coordinate
        self.url = url
        
        super.init()
    }
    
    var title: String? { return student }
    var subtitle: String? { return url }
}
