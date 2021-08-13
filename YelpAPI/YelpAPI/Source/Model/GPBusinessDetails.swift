//
//  GPBusinessDetails.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/13/21.
//

import Foundation

public struct GPBusinessDetails: Codable, Identifiable {
    public let id: String?
    public let name: String?
    public let image_url: String?
    public let is_closed: Bool?
    public let url: String?
    public let phone: String?
    public let display_phone: String?
    public let review_count: Int?
    public let categories: [GPCategories]?
    public let coordinates: GPCoordinates?
    public let rating: Double?
    public let location: GPLocation?
    public let photos: [String]?
    public let price: String?
    public let hours: [GPOperatingDetails]?
    
    public init(id: String?, name: String?, image_url: String?, is_closed: Bool?, url: String?, phone: String?, display_phone: String?, review_count: Int?, categories: [GPCategories]?, coordinates: GPCoordinates?, rating: Double?, location: GPLocation?, photos: [String]?, price: String?, hours: [GPOperatingDetails]?) {
        self.id = id
        self.name = name
        self.image_url = image_url
        self.is_closed = is_closed
        self.url = url
        self.phone = phone
        self.display_phone = display_phone
        self.review_count = review_count
        self.categories = categories
        self.coordinates = coordinates
        self.rating = rating
        self.location = location
        self.photos = photos
        self.price = price
        self.hours = hours
    }
}

public struct GPLocation: Codable {
    public let address1: String?
    public let address2: String?
    public let address3: String?
    public let city: String?
    public let zip_code: String?
    public let country: String?
    public let state: String?
    public let display_address: [String]?
    public let cross_streets: String?
    
    public init(address1: String?, address2: String?, address3: String?, city: String?, zip_code: String?, country: String?, state: String?, display_address: [String]?, cross_streets: String?) {
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.city = city
        self.zip_code = zip_code
        self.country = country
        self.state = state
        self.display_address = display_address
        self.cross_streets = cross_streets
    }
}

public struct GPOperatingDetails: Codable {
    public let open: [GPOperationHours]?
    
    public init(open: [GPOperationHours]?) {
        self.open = open
    }
}

public struct GPOperationHours: Codable {

    public let is_overnight: Bool?
    public let start: String?
    public let end: String?
    public let day: Int?
    
    public init(is_overnight: Bool?, start: String?, end: String?, day: Int?) {
        self.is_overnight = is_overnight
        self.start = start
        self.end = end
        self.day = day
    }
}
