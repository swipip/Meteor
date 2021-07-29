//
//  LocalWeatherCell.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit

class LocalWeatherCell: UICollectionViewCell, Reusable {
    static var reuseId = "LocalWeatherCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    var model: OWResultModel? {
        didSet {
            let uiPack = model?.weather.first?.getWeatherUIPack(config: .init(pointSize: 120))
            backgroundColor = uiPack?.color
            model?.coord.getPlacemark() { [weak self] placemark in
                self?.cityName.text = placemark?.locality
            }
            temperature.text = model?.main.tempCelsius
            weatherDescription.text = model?.weather.first?.description
            imageView.image = uiPack?.image
        }
    }
    
    
    
}
