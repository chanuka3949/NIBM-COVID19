//
//  LocationService.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/4/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import CoreLocation
import GeoFire
import Firebase

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationHandler()
    
    let databaseRef = Database.database().reference()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    var currentUser = Auth.auth().currentUser?.uid
    
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
            break
        default:
            break
        }
    }
    
    func getNearbyUserLocations(location: CLLocation, completion: @escaping(String, CLLocation) -> Void) {
        let geofireRef = databaseRef.child(Constants.userLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geofireRef.observe(.value) { (snapshot) in
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                print("DEBUG: User Data retrieved")
                completion(uid, location)
            }
            )
        }
    }
    
    func getDistancingUserLocations(location: CLLocation, completion: @escaping(String, CLLocation) -> Void) {
        let geofireRef = databaseRef.child(Constants.userLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geofireRef.observe(.value) { (snapshot) in
            geoFire.query(at: location, withRadius: 50).observe(.keyExited, with: { (uid, location) in
                print("DEBUG: User Data retrieved")
                completion(uid, location)
            }
            )
        }
    }
    
    func updateUserLocation(uid: String) {
        let geofireRef = databaseRef.child(Constants.userLocations)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentUser != nil {
            updateUserLocation(uid: currentUser!)
        }
    }
}
