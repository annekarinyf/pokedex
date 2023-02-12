//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation
import UIKit

struct PokemonDetailViewModel {
    let image: UIImage?
    let title: String
    let backgroundColor: UIColor?
    let baseStats = "Base Stats"
    let baseExp = "exp"
    let baseExperience: Int
    let heightLabel = "HEIGHT: "
    let weightLabel = "WEIGHT: "
    let height: String
    let weight: String
    let types: [(type: String, color: UIColor)]
    let stats: [(stat: String, value: Int)]
    let maxStatValue = 300
    let maxExpValue = 1000
    
    init(presentableModel: PokemonDetailPresentableModel) {
        self.image = presentableModel.image
        self.title = "\(presentableModel.number) - \(presentableModel.name)"
        self.backgroundColor = presentableModel.types.first?.color.withAlphaComponent(0.25)
        self.baseExperience = presentableModel.baseExperience
        self.height = presentableModel.height
        self.weight = presentableModel.weight
        self.types = presentableModel.types
        self.stats = presentableModel.stats
    }
}
