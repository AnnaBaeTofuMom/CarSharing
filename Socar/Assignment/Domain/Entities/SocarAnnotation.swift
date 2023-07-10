//
//  SocarAnnotation.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import Foundation
import MapKit

class SocarAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let zone: Zone

    init(zone: Zone) {
        self.zone = zone
        self.coordinate = CLLocationCoordinate2D(latitude: zone.lat, longitude: zone.lng)
        super.init()
    }
}
