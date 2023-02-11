//
//  RemotePokemonListMapper.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct RemotePokemonListMapper {
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [PokemonItem] {
        guard
            response.isOK,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemotePokemonListLoader.Error.invalidData
        }
        
        return root.results.map { PokemonItem(name: $0.name, url: $0.url) }
    }
}

// MARK: Decodable Models
private extension RemotePokemonListMapper {
    struct Root: Decodable {
        let count: Int
        let next: URL?
        let previous: URL?
        let results: [DecodablePokemonItem]
        
        struct DecodablePokemonItem: Decodable {
            let name: String
            let url: URL
        }
    }
}
