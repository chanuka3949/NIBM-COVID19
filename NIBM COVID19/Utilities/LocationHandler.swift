//
//  LocationService.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/4/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import CoreLocation
import GeoFire

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationHandler()
    
    
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
    
    func getNearbyUserLocations(location: CLLocation, completion: @escaping(String, CLLocation) -> Void) {
        let geofireRef = DatabaseService.databaseReference.child(Constants.userLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geofireRef.observe(.value) { (snapshot) in
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                print("DEBUG: User added to map")
                completion(uid, location)
            }
            )
        }
    }
    
    func updateUserLocation(uid: String) {
        let geofireRef = DatabaseService.databaseReference.child(Constants.userLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        guard let location = self.locationManager?.location else { return }
        
        geoFire.setLocation(location, forKey: uid) { (error) in
            if (error != nil) {
                print("An error occured: \(error!)")
                return
            }
            print("User Location Updated")
        }
    }
}
