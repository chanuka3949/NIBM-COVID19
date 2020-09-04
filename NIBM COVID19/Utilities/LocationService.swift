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
    
    func getLocationServicePermission() {
           
           switch CLLocationManager.authorizationStatus() {
           case .notDetermined:
               locationManager?.requestWhenInUseAuthorization()
           case .authorizedWhenInUse:
               locationManager?.requestAlwaysAuthorization()
           case .authorizedAlways:
               locationManager?.startUpdatingLocation()
               locationManager?.desiredAccuracy = kCLLocationAccuracyBest
           case .restricted, .denied:
               //give the option to take the user to settings page to allow access
               break
           default:
               break
           }
       }
    
}
