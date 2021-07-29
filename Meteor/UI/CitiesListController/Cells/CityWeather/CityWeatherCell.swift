//
//  CityWeatherCell.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit
import CoreLocation

class CityWeatherCell: UICollectionViewCell, Reusable {
    static var reuseId = "CityWeatherCell"
    
    @IBOutlet weak var subLocality: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var model: OWResultModel? {
        didSet {
            updateView()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateView() {
        model?.coord.getPlacemark() { [weak self] placemark in
            self?.cityName.text = placemark?.locality
            self?.subLocality.text = placemark?.subLocality
        }
        weatherDescription.text = model?.weather.first?.description
        temperature.text = model?.main.tempCelsius
        imageView.image = model?.weather.first?.getWeatherUIPack(config: .init(pointSize: 35))?.image
    }
}
