//
//  RemotePokemonListMapper.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct RemotePokemonListMapper {
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> PokemonList {
        guard
            response.isOK,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemotePokemonListLoader.Error.invalidData
        }
        
        return PokemonList(
            nextURL: root.next,
            items: root.results.map { PokemonListItem(url: $0.url) }
        )
    }
}

// MARK: Decodable Models
private extension RemotePokemonListMapper {
    struct Root: Decodable {
        let next: URL?
        let results: [DecodablePokemonItem]
        
        struct DecodablePokemonItem: Decodable {
            let url: URL
        }
    }
}
