//
//  GPDetailsService.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/13/21.
//

import Foundation
import Combine

public struct GPDetailsService {
    public static func getBusinessDetails(forID id: String) -> AnyPublisher<GPBusinessDetails, Error> {
        return GPAPIService.request(resource: GPAPIResource.getBusinessDetail(id: id))
    }
}
