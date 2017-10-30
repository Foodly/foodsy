//
//  Annotation.swift
//  foodsy
//
//  Created by drishi on 10/29/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    var mapItem: MKMapItem!
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
