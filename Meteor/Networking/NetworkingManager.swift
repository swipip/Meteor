//
//  NetworkingManager.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import Foundation
import CoreLocation

class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private let apiKey = "c37a17545d6240c6424587a62e26c319"
    private let openWeatherRoot = "https://api.openweathermap.org/data/2.5/weather"

    typealias OWCompletionBlock = (Result<OWResultModel,Error>)->()
    
    func loadWeather(foLocation location: CLLocation, completion: @escaping OWCompletionBlock) {
        guard let url = URL(string: getUrlString(forLocation: location)) else {return}
        
        let session = URLSession.shared
        let task = session.dataTask(with: .init(url: url)) { data, response, error in
            DispatchQueue.main.async {
                completion(self.completionHandler(data, response, error))
            }
        }
        task.resume()
    }

    private func completionHandler(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<OWResultModel,Error> {
        if let err = error {
            return .failure(err)
        } else if let data = data,
                  let model = self.decodeResult(from: data, to: OWResultModel.self) {
            return .success(model)
        } else {
            return .failure(NSError(domain: "An error occured", code: 0, userInfo: [:]))
        }
    }
    
    private func getUrlString(forLocation location: CLLocation) -> String {
        return openWeatherRoot
            + "?"
            + location.OWQuery
            + "&"
            + Locale.OWCustomLocale(lang: "fr")
            + "&appid=\(apiKey)"
    }

    private func decodeResult<T: Decodable>(from data: Data, to type: T.Type) -> T? {
        do {
            let model = try JSONDecoder().decode(type, from: data)
            return model
        } catch {
            print(error)
            return nil
        }
    }
    
}

fileprivate extension CLLocation {
    ///The query element for openWeather
    var OWQuery: String {
        return String(format: "lat=%f&lon=%f",
                      self.coordinate.latitude,
                      self.coordinate.longitude)
    }
}
fileprivate extension Locale {
    static var OWLocaleQuery: String {
        return "lang=\(Locale.current.languageCode ?? "en")"
    }
    static func OWCustomLocale(lang: String) -> String {
        return "lang=\(lang)"
    }
}
