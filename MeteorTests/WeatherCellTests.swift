//
//  WeatherCellTests.swift
//  MeteorTests
//
//  Created by Gautier Billard on 29/07/2021.
//

import XCTest
@testable import Meteor

class WeatherCellTests: XCTestCase {
    
    var cell: CityWeatherCell?
    
    override func setUp() {
        super.setUp()
        cell = Bundle.main.loadNibNamed("CityWeatherCell", owner: nil, options: [:])?.first as? CityWeatherCell
    }
    
    func test_UIUpdate() {
        
        var weather = OWResultModel.new()
        weather.main.temp = 270
        
        if let cell = cell {
            cell.model = weather
            XCTAssertEqual(cell.temperature.text, weather.main.tempCelsius)
        } else {
            XCTFail()
        }
        
    }
    
    func test_MemoryLeak() throws {
        let sut = Bundle.main.loadNibNamed("CityWeatherCell", owner: nil, options: [:])?.first as? CityWeatherCell
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }
    }
    
}
