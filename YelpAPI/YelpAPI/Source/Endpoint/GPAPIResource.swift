//
//  GPAPI.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/12/21.
//

import Foundation
import Alamofire

struct CONFIG {
    static let API = "https://api.yelp.com/v3"
    static let APIKey = "DnMfqceb2YzJudQI4MX6uamG_UYghp4AAmOVuY0TKQK21sxWpAz2pHkFkL-HZ4gmjEoiEPsyx5t_BKl_mxC8pyOPG8dhgarzgfopKM_CMbCgF8ZrMECjd3fpeScUYXYx"
    static let APIClientID = "1ce2VYMbCnywkZZ-K20PlA"
}

public enum GPAPIResource {
    case searchByLocation(location: String, term: String?, sortBy: String?, radius: Double?, categories: String?)
    case searchByLatLong(latitude: Double, longitude: Double, term: String?, sortBy: String?, radius: Double?, categories: String?)
}

extension GPAPIResource {
    var baseURL: URL {
        return URL(string: CONFIG.API)!
    }
    
    var path: String {
        switch self {
        case .searchByLocation,
             .searchByLatLong:
            return "/businesses/search"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .searchByLocation(location: let location,
                               term: let term,
                               sortBy: let sortBy,
                               radius: let radius,
                               categories: let categories):
            return [
                "location": location,
                "term": term ?? "",
                "radius": radius ?? "",
                "sort_by": sortBy ?? "",
                "categories": categories ?? ""]
                .filter { element in
                    if let value = element.value as? String {
                        return !value.isEmpty
                    }
                    return true
                }
        case .searchByLatLong(latitude: let latitude,
                              longitude: let longitude,
                              term: let term,
                              sortBy: let sortBy,
                              radius: let radius,
                              categories: let categories):
            return [
                "latitude": latitude,
                "longitude": longitude,
                "term": term ?? "",
                "radius": radius ?? "",
                "sort_by": sortBy ?? "",
                "categories": categories ?? ""]
                .filter { element in
                    if let value = element.value as? String {
                        return !value.isEmpty
                    }
                    return true
                }
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
        
    }
    
    var headers: HTTPHeaders {
        return [.authorization(bearerToken: CONFIG.APIKey),
                .contentType("application/json")]
    }
    
    var fullURL: String {
        return "\(baseURL)\(path)"
    }
    
    var decoder: DataDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
