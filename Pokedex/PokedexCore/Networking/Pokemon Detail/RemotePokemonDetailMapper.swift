//
//  RemotePokemonDetailMapper.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public struct RemotePokemonDetailMapper {
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> PokemonDetail {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard response.isOK,
            let root = try? decoder.decode(Root.self, from: data)
        else {
            throw RemotePokemonDetailLoader.Error.invalidData
        }
        
        return PokemonDetail(
            id: root.id,
            name: root.name,
            weight: root.weight,
            height: root.height,
            types: root.types.map { PokemonType(rawValue: $0.type.name ) ?? .other },
            stats: root.stats.map { PokemonDetail.Stat(name: $0.stat.name, baseStat: $0.baseStat) } ,
            baseExperience: root.baseExperience,
            spriteURL: root.sprites.frontDefault
        )
    }
}

// MARK: Decodable Models
private extension RemotePokemonDetailMapper {
    struct Root: Decodable {
        let id: Int
        let name: String
        let weight: Float
        let height: Float
        let baseExperience: Int
        let types: [DecodableTypes]
        let stats: [DecodableStats]
        let sprites: DecodableSprites
        
        struct DecodableTypes: Decodable {
            let type: DecodableType
            
            struct DecodableType: Decodable {
                let name: String
            }
        }
        
        struct DecodableStats: Decodable {
            let baseStat: Int
            let stat: DecodableStat
            
            struct DecodableStat: Decodable {
                let name: String
            }
        }
        
        struct DecodableSprites: Decodable {
            let frontDefault: URL
        }
    }
}
