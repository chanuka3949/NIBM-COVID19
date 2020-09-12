//
//  MapViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private lazy var mapView = MKMapView()
    private var locationManager = LocationHandler.sharedInstance.locationManager
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationHandler.sharedInstance.getLocationServicePermission()
        setupUserLocation()
        getNearbyUsers()
    }
    
    func setupUserLocation() {

        mapView.delegate = self
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        guard let location = locationManager?.location else {return}
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func getNearbyUsers() {
        guard let location = locationManager?.location else {return}
        print("Getting nearby users")
        LocationHandler.sharedInstance.getNearbyUserLocations(location: location) { (uid, location) in
            print("DEBUG: \(uid)")
            print("DEBUG: \(location)")
            //get health data to get risk level and change the annotation color accordingly
            let annotation = UserAnnotation(uid: uid, coordinate: location.coordinate, color: .blue)
            
            var userAlreadyVisible: Bool {
                return self.mapView.annotations.contains { (userAnnotation) -> Bool in
                    guard let userAnnotation = userAnnotation as? UserAnnotation else {return false}
                    if userAnnotation.uid == annotation.uid {
                        print("DEBUG: User already exists in map")
                        //update user location
                        userAnnotation.coordinate = annotation.coordinate
                        return true
                    }
                    return false
                }
            }
            if !userAlreadyVisible {
                print("DEBUG: User annotation added to map \(annotation.uid)")
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UserAnnotation {
            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.uid)
            view.markerTintColor = annotation.color
            return view
        }
        return nil
    }
}
