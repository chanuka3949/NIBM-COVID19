//
//  MapViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController {
    private lazy var mapView = MKMapView()
    private var locationManager = LocationHandler.sharedInstance.locationManager
    private let currentUser = Auth.auth().currentUser?.uid
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
    
    func getUserRiskLevels(uid: String, completion: @escaping(Int) -> Void) {
        var riskLevel = 0
        Database.database().reference().child(Constants.userHealth).child(Constants.surveySummary).child(uid).observe(.childAdded, with: { (snapshot) -> Void in
            riskLevel = snapshot.value as! Int
            completion(riskLevel)
        })
    }
    
    func getNearbyUsers() {
        guard let location = locationManager?.location else {return}
        LocationHandler.sharedInstance.getNearbyUserLocations(location: location) {[weak self] (uid, location) in
            if (uid == self?.currentUser) {
                print("Current user")
                return
            }
            self?.getUserRiskLevels(uid: uid, completion: {(riskLevel) in
                var color: UIColor = .systemBlue
                switch riskLevel {
                case 5:
                    color = .red
                case 4:
                    color = .red
                case 3:
                    color = .yellow
                case 2:
                    color = .yellow
                case 1:
                    color = .green
                case 0:
                    color = .green
                default:
                    break
                }
                let annotation = UserAnnotation(uid: uid, coordinate: location.coordinate, color: color)
                var userAlreadyVisible: Bool? {
                    return (self?.mapView.annotations.contains { (userAnnotation) -> Bool in
                        guard let userAnnotation = userAnnotation as? UserAnnotation else {return false}
                        if userAnnotation.uid == annotation.uid {
                            print("DEBUG: User already exists in map")
                            userAnnotation.coordinate = annotation.coordinate
                            userAnnotation.color = annotation.color
                            return true
                        }
                        return false
                        })
                }
                if !(userAlreadyVisible ?? true) {
                    print("DEBUG: User annotation added to map \(annotation.uid)")
                    self?.mapView.addAnnotation(annotation)
                }
            })
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
