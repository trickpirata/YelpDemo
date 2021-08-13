//
//  Business.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/12/21.
//

import Foundation

public struct GPBusiness: Codable, Identifiable {
    public let id: String?
    public let name: String?
    public let price: String?
    public let distance: Double?
    public let rating: Double?
    public let image_url: String?
    public let categories: [GPCategories]?
    public let coordinates: GPCoordinates?
    public let url: String?
    public let phone: String?
    
    public init(id: String?, name: String?, price: String?, distance: Double?, rating: Double?, imageUrl: String?, categories: [GPCategories]?, coordinates: GPCoordinates?, url: String?, phone: String?) {
        self.id = id
        self.name = name
        self.price = price
        self.distance = distance
        self.rating = rating
        self.image_url = imageUrl
        self.categories = categories
        self.coordinates = coordinates
        self.url = url
        self.phone = phone
    }
}

public struct GPCategories: Codable {
    public let alias: String?
    public let title: String?
    public init(alias: String?, title: String?) {
        self.alias = alias
        self.title = title
    }
}

public struct GPCoordinates: Codable {
    public let latitude: Double?
    public let longitude: Double?
    
    public init(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
