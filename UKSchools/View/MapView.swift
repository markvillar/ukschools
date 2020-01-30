//
//  MapView.swift
//  UKSchools
//
//  Created by Mark on 28/01/2020.
//  Copyright © 2020 UK Schools. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController {
    
    let network: NetworkLayer = NetworkLayer()
    
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    let mapView: MKMapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    fileprivate func getCoordinateBounds(region: MKCoordinateRegion) -> Bounds {
        
        // Get the bounding region of the map
        let south = region.center.latitude - (region.span.latitudeDelta / 2.0);
        let north = region.center.latitude + (region.span.latitudeDelta / 2.0);
        
        let west = region.center.longitude - (region.span.longitudeDelta / 2.0);
        let east = region.center.longitude + (region.span.longitudeDelta / 2.0);
        
        //Create the bounds
        let bounds = Bounds(latitudeNorth: north, latitudeSouth: south, longitudeEast: east, longitudeWest: west)
        
        return bounds
    }
    
    fileprivate func setupView() {
        navigationItem.title = "UK Schools"
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.523140, longitude: -0.119211)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

//MapKit Delegate
extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.setCenter(view.annotation!.coordinate, animated: true)
        
        if let title = view.annotation?.title {
            self.navigationItem.title = title
        }
        
    }
    
    /// Delegate function that calls the API when the user scrolls or pans around the map
    /// - Parameters:
    ///   - mapView: MKMapView
    ///   - animated: Bool
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        //Remove all annotations (if any)
        mapView.annotations.forEach { annotation in
            mapView.removeAnnotation(annotation)
        }
        
        let bounds = getCoordinateBounds(region: mapView.region)
        
        //Retrive the schools from the API
        self.network.getSchools(bounds: bounds) { schools, error in
            
            if let error = error {
                AlertController.customAlert(title: "Retrieve Error", message: error.localizedDescription, on: self)
            }
            
            if let resultingSchools = schools {
                resultingSchools.forEach { [weak self] school in
                    
                    self?.addAnnotation(school: school)
                    
                }
            }
            
        }
        
    }
    
    /// Creates a red pin annotation for a school on the map
    /// - Parameter school: School
    fileprivate func addAnnotation(school: School) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: school.latitude, longitude: school.longitude)
        annotation.title = school.school_name
        annotation.subtitle = "School"
        
        mapView.addAnnotation(annotation)
        
    }
    
}
