//
//  UINavigationBar.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit

extension UINavigationBar {
    static func setAppDefaultLayout() {
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
