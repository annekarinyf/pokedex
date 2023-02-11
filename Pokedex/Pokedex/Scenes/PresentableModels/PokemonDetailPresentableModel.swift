//
//  PokemonDetailPresentableModel.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation
import UIKit

struct PokemonDetailPresentableModel {
    let name: String
    let number: String
    let types: [(type: String, color: UIColor)]
    let stats: [(stat: String, value: Int)]
    let baseExperience: Int
    let height: String
    let weight: String
    var image: UIImage?
}
