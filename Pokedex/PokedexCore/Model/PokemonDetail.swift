//
//  PokemonDetail.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct PokemonDetail {
    public let id: Int
    public let name: String
    public let weight: Float
    public let height: Float
    public let types: [PokemonType]
    public let stats: [Stat]
    public let baseExperience: Int
    public let spriteURL: URL
    
    public struct Stat {
        public let name: String
        public let baseStat: Int
    }
}

public enum PokemonType: String, CaseIterable {
    case grass
    case fire
    case water
    case eletric
    case poison
    case normal
    case ice
    case fighting
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dark
    case dragon
    case steel
    case fairy
    case unknown
}
