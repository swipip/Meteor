//
//  CityListHeader.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit

class CityListHeader: UICollectionReusableView, Reusable {
    static var reuseId = "CityListHeader"
    
    @IBOutlet weak var title: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
}
