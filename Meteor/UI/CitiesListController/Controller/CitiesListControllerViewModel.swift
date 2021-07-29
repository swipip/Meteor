//
//  CitiesListControllerViewModel.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import Foundation
import CoreLocation

protocol CitiesListControllerViewModelDelegate: AnyObject {
    func citiesListControllerViewModel(didLoadWeather weather: [OWResultModel])
    func citiesListControllerViewModel(didLoadLocalWeather weather: OWResultModel?, otherCities: [OWResultModel])
}
class CitiesListControllerViewModel {
    
    weak var delegate: CitiesListControllerViewModelDelegate?
    
    private (set) var localWeather: OWResultModel? {
        didSet {
            delegate?.citiesListControllerViewModel(
                didLoadLocalWeather: localWeather,
                otherCities: Array(results.sorted(by: {$0.name < $1.name})))
        }
    }
    private (set) var results: Set<OWResultModel> = [] {
        didSet {
            delegate?.citiesListControllerViewModel(didLoadWeather: Array(results.sorted(by: {$0.name < $1.name})))
        }
    }
    
    ///0 secondes Rennes, à 10 secondes Paris, à 20 secondes Nantes, etc pour Bordeaux et Lyon
    var defaultCities: [CLLocation] = [
        CLLocation(latitude: 48.117266, longitude: -1.6777926),
        CLLocation(latitude: 48.866667, longitude: 2.333333),
        CLLocation(latitude: 47.2186371, longitude: -1.5541362),
        CLLocation(latitude: 44.841225, longitude: -0.5800364),
        CLLocation(latitude: 45.7578137, longitude: 4.8320114)
    ]
    
    func resetResults() {
        results = []
    }
    
    func loadWeather(for location: CLLocation, isCurrentLocation: Bool) {
        NetworkingManager.shared.loadWeather(foLocation: location) { [weak self] result in
            switch result {
            case.failure(let err):
                print(err)
            case .success(let model):
                if isCurrentLocation {
                    self?.localWeather = model
                } else {
                    self?.results.insert(model)
                }
            }
        }
    }
    
}
