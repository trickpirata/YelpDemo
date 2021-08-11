//
//  GPApiService.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/12/21.
//

import Alamofire
import Combine
import Foundation

public enum GPAPIService {
    public static func request<T: Decodable>(resource: GPAPIResource) -> AnyPublisher<T, Error> {
        return AF.request(resource.fullURL,
                          method: resource.method,
                          parameters: resource.parameters,
                          headers: resource.headers)
            .publishDecodable(type: T.self)
            .tryCompactMap({ (response) -> T? in
                if let error = response.error { throw error }
                
                return response.value
            }).eraseToAnyPublisher()

    }
}
