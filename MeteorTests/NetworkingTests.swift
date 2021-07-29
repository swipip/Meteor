//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by Gautier Billard on 29/07/2021.
//

import XCTest
import CoreLocation
@testable import Meteor

class NetworkTests: XCTestCase {

    var manager = NetworkingManager()
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testNetworking() {
        let exp = self.expectation(description: "")
        var model: OWResultModel?
        
        manager.loadWeather(foLocation: CLLocation(latitude: 48.117266, longitude: -1.6777926)) { result in
            switch result {
            case .success(let m):
                model = m
            case .failure(let err):
                print(err)
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNotNil(model)
        }
    }

}
