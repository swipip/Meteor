//
//  UICollectionView.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit

protocol Reusable {
    static var reuseId: String { get }
}

extension UICollectionView {
    func dqReusableCell<T: Reusable & UICollectionViewCell>(ofType type: T.Type,for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as! T
        cell.sendSubviewToBack(cell.contentView)
        return cell
    }
    func dqHeader<T: Reusable & UICollectionReusableView>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        let header = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseId, for: indexPath) as! T
        return header
    }
    func registerNib<T: Reusable & UICollectionViewCell>(ofType type: T.Type) {
        self.register(UINib(nibName: T.reuseId, bundle: nil), forCellWithReuseIdentifier: T.reuseId)
    }
    func register<T: Reusable & UICollectionViewCell>(cellOfType type: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseId)
    }
    func registerHeaderNib<T: Reusable & UICollectionReusableView>(ofType type: T.Type) {
        self.register(UINib(nibName: type.reuseId, bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseId)
    }
}

extension UIEdgeInsets {
    static func all(_ padding: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}
