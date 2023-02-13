//
//  PokemonDetail.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct PokemonDetail: Equatable {
    public let id: Int
    public let name: String
    public let weight: Float
    public let height: Float
    public let types: [PokemonType]
    public let stats: [Stat]
    public let baseExperience: Int
    public let spriteURL: URL
    
    public init(
        id: Int,
        name: String,
        weight: Float,
        height: Float,
        types: [PokemonType],
        stats: [PokemonDetail.Stat],
        baseExperience: Int,
        spriteURL: URL
    ) {
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.types = types
        self.stats = stats
        self.baseExperience = baseExperience
        self.spriteURL = spriteURL
    }
    
    public struct Stat: Equatable {
        public let name: String
        public let baseStat: Int
        
        public init(name: String, baseStat: Int) {
            self.name = name
            self.baseStat = baseStat
        }
    }
}

public enum PokemonType: String, CaseIterable, Equatable {
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
