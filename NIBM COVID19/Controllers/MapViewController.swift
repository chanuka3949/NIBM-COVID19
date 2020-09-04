//
//  MapViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = LocationService.sharedInstance.locationManager
    private var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationServicePermission()
        setupUserLocation()
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
    
    
    func setupUserLocation() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
