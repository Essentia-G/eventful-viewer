//
//  MapPin.swift
//  EventfulViewer
//
//  Created by Станислава on 28/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

