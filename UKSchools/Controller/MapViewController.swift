//
//  MapViewController.swift
//  UKSchools
//
//  Created by Mark on 25/01/2020.
//  Copyright © 2020 UK Schools. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let apiURL = URL(string: "https://ukschools.guide:4000/map-demo")
    
    @IBOutlet weak var mapView: MKMapView!
    
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "UK Schools"
        
        setupView()
    }
    
    
    fileprivate func setupView() {
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.523140, longitude: -0.119211)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    fileprivate func getSchools(bounds: Bounds, completion: @escaping ([School]?, Error?) -> ()) {
        
        var request = URLRequest(url: apiURL!)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let area = Bounds(latitudeNorth: bounds.latitudeNorth, latitudeSouth: bounds.latitudeSouth, longitudeEast: bounds.longitudeEast, longitudeWest: bounds.longitudeWest)
        
        //        let area = Bounds(latitudeNorth: "51.54126776718752", latitudeSouth: "51.48964361688991", longitudeEast: "-0.1391464811950982", longitudeWest: "-0.1890868820194953")
        
        request.httpMethod = "POST"
        
        do {
            let body = try JSONEncoder().encode(area)
            request.httpBody = body
        } catch {
            print("Failed to encode: ", error)
        }
        
        // Send the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for error
            if let err = error {
                completion(nil, err)
                print("Failed to encode data: ", err)
                return
            }
            
            // Check if the response contains some decodable data
            if let data = data {
                
                // Proceed to decode the data
                do {
                    let retrievedData = try JSONDecoder().decode([School].self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(retrievedData, nil)
                    }
                    
                } catch let jsonError {
                    AlertController.customAlert(title: "Decoding Error", message: jsonError.localizedDescription, on: self)
                }
                
            }
            
        }.resume()
        
    }
    
}


//MapKit Delegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.setCenter(view.annotation!.coordinate, animated: true)
        
        if let title = view.annotation?.title {
            self.navigationItem.title = title
        }
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        mapView.annotations.forEach { annotation in
            mapView.removeAnnotation(annotation)
        }
        
        let region = mapView.region
        // Get the bounding region of the map
        let south = region.center.latitude - (region.span.latitudeDelta / 2.0);
        let north = region.center.latitude + (region.span.latitudeDelta / 2.0);
        
        let west = region.center.longitude - (region.span.longitudeDelta / 2.0);
        let east = region.center.longitude + (region.span.longitudeDelta / 2.0);
        
        //Create the bounds
        let bound = Bounds(latitudeNorth: north, latitudeSouth: south, longitudeEast: east, longitudeWest: west)
        
        
        //Retrive the schools from the API
        getSchools(bounds: bound) { schools, error in
            
            if let error = error {
                AlertController.customAlert(title: "Retrieve Error", message: error.localizedDescription, on: self)
            }
            
            if let resultingSchools = schools {
                resultingSchools.forEach { school in
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: school.latitude, longitude: school.longitude)
                    annotation.title = school.school_name
                    annotation.subtitle = "School"
                    
                    mapView.addAnnotation(annotation)
                }
            }
            
        }
    }
    
}
