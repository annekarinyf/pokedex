//
//  UICollectionViewCell+Rounded.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

extension UICollectionViewCell {
    func setRoundedLayout() {
        contentView.layer.cornerRadius = 15.0
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 15.0
        layer.masksToBounds = false
    }
}
