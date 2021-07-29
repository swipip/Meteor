//
//  UIButton.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit

extension UIButton {
    ///Sets the button to app's button primary style
    func primaryOutlined() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.setTitleColor(.white, for: .normal)
        self.tintColor = .white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func backPlain() {
        self.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        self.setImage(UIImage(systemName: "chevron.left.circle.fill", withConfiguration: config), for: .normal)
    }
}
