//
//  OWModel.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit
import CoreLocation

struct OWResultModel: Codable, Hashable {
    var coord: OWCoord
    var main: OWResultMain
    var weather: [OWWeather]
    var name: String
    var clouds: OWClouds
    var wind: OWWind
    var visibility: Float
}
struct OWCoord: Codable, Hashable {
    var lon: Double
    var lat: Double
    var clLocation: CLLocation {
        return CLLocation(latitude: lat, longitude: lon)
    }
    func getPlacemark(_ completion: @escaping (_ placemark: CLPlacemark?)->()) {
        
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let err = error {
                print(err)
            } else if let placemark = placemarks?.first {
                completion(placemark)
            }
        }
        
    }
    static func new() -> OWCoord{
        return OWCoord(lon: 0, lat: 0)
    }
}
struct OWResultMain: Codable, Hashable {
    var temp: Float
    var tempCelsius: String {
        return String(format: "%.1f", (temp - 270)) + " °"
    }
    var feels_like: Float
    var temp_min: Float
    var temp_max: Float
    var pressure: Float
    var humidity: Float
    static func new() -> OWResultMain{
        return OWResultMain(temp: 0, feels_like: 0, temp_min: 0, temp_max: 0, pressure: 0, humidity: 0)
    }
}
struct OWWeather: Codable, Hashable {
    var id: Float
    var main: String
    var description: String
    var icon: String
    
    func getWeatherUIPack(config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25)) -> UIWeatherPack? {
        let rootId = String(icon.dropLast())
        switch rootId {
        case "01":
            //Clear sky
            return .init(image: UIImage(systemName: "sun.max.fill", withConfiguration: config), color: K.colors.weather2)
        case "02":
            //Few clouds
            return UIWeatherPack(image: UIImage(systemName: "cloud.sun.fill", withConfiguration: config), color: K.colors.weather1)
        case "03":
            //scattered clouds
            return UIWeatherPack(image: UIImage(systemName: "cloud.fill", withConfiguration: config), color: K.colors.weather3)
        case "04":
            //broken clouds
            return UIWeatherPack(image: UIImage(systemName: "cloud.fill", withConfiguration: config), color: K.colors.weather3)
        case "09":
            //shower rain
            return UIWeatherPack(image: UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: config), color: K.colors.weather3)
        case "10":
            //rain
            return UIWeatherPack(image: UIImage(systemName: "cloud.sun.rain.fill", withConfiguration: config), color: K.colors.weather3)
        case "11":
            //Thunder
            return UIWeatherPack(image: UIImage(systemName: "cloud.bolt.rain.fill", withConfiguration: config), color: K.colors.weather3)
        case "13":
            //snow
            return UIWeatherPack(image: UIImage(systemName: "cloud.snow.fill", withConfiguration: config), color: K.colors.weather3)
        case "50":
            //mist
            return UIWeatherPack(image: UIImage(systemName: "cloud.fog.fill", withConfiguration: config), color: K.colors.weather3)
        default:
            return UIWeatherPack(image: UIImage(systemName: "sun.max.fill", withConfiguration: config), color: K.colors.weather2)
        }
    }
    
    static func new() -> OWWeather{
        return OWWeather(id: 0, main: "", description: "", icon: "")
    }
    
}
struct OWClouds: Codable, Hashable {
    var all: Float
    static func new() -> OWClouds {
        return OWClouds(all: 10)
    }
}
struct OWWind: Codable, Hashable {
    var speed: Float
    var deg: Float
    var gust: Float?
    static func new() -> OWWind {
        return OWWind(speed: 10, deg: 10, gust: 0)
    }
}

struct UIWeatherPack {
    var image: UIImage?
    var color: UIColor?
}

// MARK: Mocking

extension OWResultModel {
    static func new() -> OWResultModel {
        return OWResultModel(
            coord: .new(), main: .new(), weather: [.new()], name: "", clouds: .new(), wind: .new(), visibility: 10)
    }
}
