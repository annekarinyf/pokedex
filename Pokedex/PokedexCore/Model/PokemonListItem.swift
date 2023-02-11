//
//  PokemonItem.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct PokemonList {
    public let nextURL: URL?
    public let items: [PokemonListItem]
}

public struct PokemonListItem {
    public let url: URL
}
