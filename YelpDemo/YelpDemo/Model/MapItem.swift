//
//  MapItem.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/13/21.
//

import Foundation
import CoreLocation

struct MapItem: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    internal init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}
