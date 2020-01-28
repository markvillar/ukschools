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
    
    let mapView: MKMapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        navigationItem.title = "UK Schools"
        
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
