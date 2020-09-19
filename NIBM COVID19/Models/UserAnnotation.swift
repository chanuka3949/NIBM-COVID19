//
//  UserAnnotation.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/4/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var uid: String
    var color: UIColor
    var riskLevel: Int
    
    init(uid: String, coordinate: CLLocationCoordinate2D, color: UIColor, riskLevel: Int) {
        self.uid = uid
        self.coordinate = coordinate
        self.color = color
        self.riskLevel = riskLevel
    }
}

