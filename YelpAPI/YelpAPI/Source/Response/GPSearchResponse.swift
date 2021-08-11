//
//  SearchResponse.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/12/21.
//

import Foundation

public class GPSearchResponse: Codable {
    public let total: Int
    public let businesses: [Business]
}
