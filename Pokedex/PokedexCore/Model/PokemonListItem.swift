//
//  PokemonItem.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct PokemonList: Equatable {
    public let nextURL: URL?
    public let items: [PokemonListItem]
    
    public init(nextURL: URL?, items: [PokemonListItem]) {
        self.nextURL = nextURL
        self.items = items
    }
}

public struct PokemonListItem: Equatable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
