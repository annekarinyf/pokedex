//
//  PokemonDetail+PresentableModel.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation
import PokedexCore

extension PokemonDetail {
    func toPresentableModel() -> PokemonDetailPresentableModel {
        PokemonDetailPresentableModel(
            name: name,
            number: "#\(id)",
            types: types.map { (type: $0.rawValue, color: $0.color) },
            stats: stats.map { (stat: $0.name, value: $0.baseStat) },
            height: height.toMetersFormatted(),
            weight: weight.toKilogramsFormatted()
        )
    }
}
