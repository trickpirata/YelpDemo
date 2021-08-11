//
//  Business.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/12/21.
//

import Foundation

public struct Business: Codable, Identifiable {
    public let id: String?
    public let name: String?
    public let price: String?
    public let distance: Double?
    public let imageUrl: String?
    public let categories: [Categories]?
    public let coordinates: Coordinates?
    public let url: String?
    public let phone: String?
}

public struct Categories: Codable {
    public let alias: String?
    public let title: String?
}

public struct Coordinates: Codable {
    public let latitude: Double?
    public let longitude: Double?
}
