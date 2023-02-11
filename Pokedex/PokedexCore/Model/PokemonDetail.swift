//
//  PokemonDetail.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct PokemonDetail {
    let id: Int
    let name: String
    let weight: Float
    let height: Float
    let types: [PokemonType]
    let stats: [Stat]
    let baseExperience: Int
    let spriteURL: URL
    
    struct Stat {
        let name: String
        let baseStat: Int
    }
}

enum PokemonType: String {
    case grass
    case fire
    case water
    case eletric
    case poison
    case other
}
