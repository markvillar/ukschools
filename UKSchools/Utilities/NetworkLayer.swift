//
//  NetworkLayer.swift
//  UKSchools
//
//  Created by Mark on 30/01/2020.
//  Copyright © 2020 UK Schools. All rights reserved.
//

import Foundation

class NetworkLayer {
    
    func getSchools(bounds: Bounds, completion: @escaping ([School]?, Error?) -> ()) {
        
        let apiURL = URL(string: "https://ukschools.guide:4000/map-demo")
        
        var request = URLRequest(url: apiURL!)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let area = Bounds(latitudeNorth: bounds.latitudeNorth, latitudeSouth: bounds.latitudeSouth, longitudeEast: bounds.longitudeEast, longitudeWest: bounds.longitudeWest)
        
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
                    print("JSON Error: \(jsonError)")
                    completion(nil, jsonError)
                }
                
            }
            
        }.resume()
        
    }
    
}
