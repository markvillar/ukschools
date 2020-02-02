//
//  MapViewModel.swift
//  UKSchools
//
//  Created by Mark on 25/01/2020.
//  Copyright © 2020 UK Schools. All rights reserved.
//

import UIKit
import MapKit

struct MapViewModel {
    
    private let network = NetworkLayer()
    
    func getSchools(region: MKCoordinateRegion, completion: @escaping ([School]?, Error?)->()) {
        
        // Get the bounding region of the map
        let south = region.center.latitude - (region.span.latitudeDelta / 2.0);
        let north = region.center.latitude + (region.span.latitudeDelta / 2.0);
        
        let west = region.center.longitude - (region.span.longitudeDelta / 2.0);
        let east = region.center.longitude + (region.span.longitudeDelta / 2.0);
        
        //Create the bounds
        let bounds = Bounds(latitudeNorth: north, latitudeSouth: south, longitudeEast: east, longitudeWest: west)
        
        //Retrive the schools from the API
        self.network.getSchools(bounds: bounds) { schools, error in
            
            if let error = error {
                completion(nil, error)
            }
            
            if let resultingSchools = schools {
                completion(resultingSchools, nil)
            }
            
        }
        
    }
    
}
