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

public enum PokemonType: String {
    case grass
    case fire
    case water
    case eletric
    case poison
    case other
}
