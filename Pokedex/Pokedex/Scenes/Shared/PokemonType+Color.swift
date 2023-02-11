//
//  PokemonType+Color.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import PokedexCore
import UIKit

extension PokemonType {
    var color: UIColor {
        switch self {
        case .grass:
            return .systemGreen
        case .fire:
            return .systemRed
        case .water:
            return .systemBlue
        case .eletric:
            return .systemYellow
        case .poison:
            return .systemPurple
        default:
            return .systemGray
        }
    }
}
