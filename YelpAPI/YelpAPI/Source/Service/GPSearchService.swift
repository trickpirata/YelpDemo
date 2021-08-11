//
//  GPSearchService.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/12/21.
//

import Combine

public struct GPSearchService {
    public static func search(byLocation location: String,
                              withTerm term: String?,
                              sortBy sort: String?,
                              radius: Double?,
                              andCategories categories: String?) -> AnyPublisher<GPSearchResponse, Error> {
        return GPAPIService.request(resource: GPAPIResource
                                        .searchByLocation(location: location,
                                                          term: term,
                                                          sortBy: sort,
                                                          radius: radius,
                                                          categories: categories))
    }
    
    public static func search(byLatitude lat: Double,
                              longitude long: Double,
                              withTerm term: String?,
                              sortyBy sort: String?,
                              radius: Double?,
                              andCategories categories: String?) -> AnyPublisher<GPSearchResponse, Error> {
        return GPAPIService.request(resource: GPAPIResource
                                        .searchByLatLong(latitude: lat,
                                                         longitude: long,
                                                         term: term,
                                                         sortBy: sort,
                                                         radius: radius,
                                                         categories: categories))
    }
}
