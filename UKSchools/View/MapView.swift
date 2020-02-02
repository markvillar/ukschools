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
    
    var mapViewModel: MapViewModel!
    
    let mapView: MKMapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.isScrollEnabled = true
        mapViewModel = MapViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    fileprivate func setupView() {
        navigationItem.title = "UK Schools"
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.523140, longitude: -0.119211)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
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
    
    /// Delegate function that is called when user selects/taps an annotation
    /// - Parameters:
    ///   - mapView: MKMapView
    ///   - view: MKAnnotationView
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //Center the selected annotation
        if let viewAnnotation = view.annotation {
            let coordinate = viewAnnotation.coordinate
            mapView.setCenter(coordinate, animated: true)
        }
        
        //Change the title to the annotated school's name
        if let title = view.annotation?.title {
            self.navigationItem.title = title
        }
        
    }
    
    /// Delegate function that calls the API when the user scrolls or pans around the map
    /// - Parameters:
    ///   - mapView: MKMapView
    ///   - animated: Bool
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        //Show a loading indicator
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        //Remove all annotations (if any)
        mapView.annotations.forEach { annotation in
            mapView.removeAnnotation(annotation)
        }
        
        _ = mapViewModel.getSchools(region: mapView.region) { result, err in
            
            guard let schools = result else {
                AlertController.customAlert(title: "Retrieve Error", message: err!.localizedDescription, on: self)
                return
            }
            
            //Add annotation for each school
            schools.forEach { [weak self] school in
                self?.addAnnotation(school: school)
            }
        }
        
        dismiss(animated: false, completion: nil)
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
