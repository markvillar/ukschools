//
//  School.swift
//  UKSchools
//
//  Created by Mark on 25/01/2020.
//  Copyright © 2020 UK Schools. All rights reserved.
//

import Foundation

struct School: Codable {
    
    let school_name: String
    let latitude: Double
    let longitude: Double
    
}

struct Bounds: Codable {
    
    let latitudeNorth: Double
    let latitudeSouth: Double
    let longitudeEast: Double
    let longitudeWest: Double
    
}
