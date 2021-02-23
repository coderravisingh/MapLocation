//
//  Location.swift
//  MapLocation
//
//  Created by RaviSingh on 25/01/21.
//

import Foundation
import CoreLocation

struct Location {
    let title: String
    let coordinate : CLLocationCoordinate2D?
}

class LocationManager:NSObject {
    static let shared = LocationManager()
    
//    let manager = CLLocationManager()
    
    public func findLocation(with query: String, completion: @escaping (([ Location])-> Void)) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { (places, error) in
            guard let places = places , error == nil else {
                completion([])
              return
            }
            
            let models:[Location] = places.compactMap ({ places in
                var name = ""
                if let locationName = places.name {
                    name += locationName
                }
                if let adminRegion = places.administrativeArea {
                    name += " \(adminRegion)"
                }
                if let locality = places.locality {
                    name += "\(locality)"
                }
                if let country = places.country {
                    name += "\(country)"
                }
                print("\n\(places)\n\n")
                
                let result = Location(title: name, coordinate: places.location?.coordinate)
                return result
            })
            completion(models)
            

        }
    
    }
    
    
}
