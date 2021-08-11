//
//  YelpAPITests.swift
//  YelpAPITests
//
//  Created by Trick Gorospe on 8/12/21.
//

import XCTest
import Combine
import AlamofireNetworkActivityLogger

@testable import YelpAPI

class YelpAPITests: XCTestCase {

    var cancellable: AnyCancellable?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        NetworkActivityLogger.shared.level = .debug
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellable = nil
    }
    
    func testSearchByLocationService() {
        NetworkActivityLogger.shared.startLogging()
        let currencyCallExpectation = expectation(description: "Should display searches by location")
        cancellable = GPSearchService.search(byLocation: "alabang",
                               withTerm: nil,
                               sortBy: nil,
                               radius: nil,
                               andCategories: nil)
            .print()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error.localizedDescription)
                case .finished:
                    XCTAssert(true)
                }
            }, receiveValue: { response in
                XCTAssertNotNil(response)
                currencyCallExpectation.fulfill()
            })

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testLocationByLatLong() {
        NetworkActivityLogger.shared.startLogging()
        let currencyCallExpectation = expectation(description: "Should display searches by latlong")
        cancellable = GPSearchService.search(byLatitude: 37.786882,
                                             longitude: -122.399972,
                                             withTerm: nil,
                                             sortyBy: nil,
                                             radius: nil,
                                             andCategories: nil)
            .print()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error.localizedDescription)
                case .finished:
                    XCTAssert(true)
                }
            }, receiveValue: { response in
                XCTAssertNotNil(response)
                currencyCallExpectation.fulfill()
            })

        waitForExpectations(timeout: 10, handler: nil)
    }
}
