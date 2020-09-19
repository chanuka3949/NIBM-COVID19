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
    private var lowRiskUsers = 0
    private var mediumRiskUsers = 0
    private var highRiskUsers = 0
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationHandler.sharedInstance.getLocationServicePermission()
        setupUserLocation()
        getNearbyUsers()
        removeDistancingUsers()
        view.addSubview(statusView)
        statusView.setViewConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginBottom: 5, marginLeft: 10, marginRight: 10, height: 50)
        statusView.addSubview(statusLabel)
        statusLabel.setViewConstraints(top: statusView.topAnchor, bottom: statusView.bottomAnchor, left: statusView.leftAnchor, right: statusView.rightAnchor, marginTop: 5, marginBottom: 5, marginLeft: 5, marginRight: 5)
    }
    
    func updateSurroundingStatus(riskLevel: Int, userEnteredArea: Bool) {
        switch riskLevel {
        case 5:
            highRiskUsers += 1
        case 4:
            highRiskUsers += 1
        case 3:
            mediumRiskUsers += 1
        case 2:
            mediumRiskUsers += 1
        case 1:
            lowRiskUsers += 0
        case 0:
            lowRiskUsers += 0
        default:
            break
        }
        if highRiskUsers > 0 {
            updateStatusBar(status: "High risk area. Please move away from this area", color: .systemRed)
        } else if mediumRiskUsers > 0 {
            updateStatusBar(status: "Be cautions. People might be infected", color: .systemYellow)
        } else {
            updateStatusBar(status: "This is a safe area", color: .systemGreen)
        }
    }
    
    func updateStatusBar(status: String, color: UIColor) {
        statusLabel.text = status
        statusView.backgroundColor = color
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
        Database.database().reference().child(Constants.userHealth).child(Constants.surveySummary).child(uid).observe(.value, with: { (snapshot) -> Void in
            if let riskLevel = snapshot.childSnapshot(forPath: "riskLevel").value as? Int {
                completion(riskLevel)
            }
        })
    }
    
    func removeDistancingUsers() {
        guard let location = locationManager?.location else {return}
        LocationHandler.sharedInstance.getDistancingUserLocations(location: location, completion: { [weak self] (userId, location) in
            _ = self?.mapView.annotations.contains { [weak self] (userAnnotation) -> Bool in
                guard let userAnnotation = userAnnotation as? UserAnnotation else {return false}
                if userAnnotation.uid == userId {
                    self?.mapView.removeAnnotation(userAnnotation)
                    self?.updateSurroundingStatus(riskLevel: userAnnotation.riskLevel, userEnteredArea: false)
                    return true
                }
                return false
            }
            }
        )
    }
    
    func getNearbyUsers() {
        guard let location = locationManager?.location else {return}
        LocationHandler.sharedInstance.getNearbyUserLocations(location: location) {[weak self] (uid, location) in
            if (uid == self?.currentUser) {
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
                let annotation = UserAnnotation(uid: uid, coordinate: location.coordinate, color: color, riskLevel: riskLevel)
                var userAlreadyVisible: Bool? {
                    return (self?.mapView.annotations.contains { [weak self] (userAnnotation) -> Bool in
                        guard let userAnnotation = userAnnotation as? UserAnnotation else {return false}
                        if userAnnotation.uid == annotation.uid {
                            userAnnotation.coordinate = annotation.coordinate
                            if userAnnotation.color != annotation.color {
                                self?.mapView.removeAnnotation(userAnnotation)
                                self?.mapView.addAnnotation(annotation)
                                self?.updateSurroundingStatus(riskLevel: riskLevel, userEnteredArea: true)
                            }
                            return true
                        }
                        return false
                        })
                }
                if !(userAlreadyVisible ?? true) {
                    self?.mapView.addAnnotation(annotation)
                    self?.updateSurroundingStatus(riskLevel: riskLevel, userEnteredArea: true)
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
