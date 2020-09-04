//
//  LocationService.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/4/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
