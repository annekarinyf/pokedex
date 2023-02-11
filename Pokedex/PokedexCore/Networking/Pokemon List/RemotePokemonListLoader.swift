//
//  RemotePokemonListLoader.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public protocol PokemonListLoader {
    typealias Result = Swift.Result<PokemonList, Error>
    func load(from url: URL, completion: @escaping (PokemonListLoader.Result) -> Void)
}

public final class RemotePokemonListLoader: PokemonListLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(client: HTTPClient) {
        self.client = client
    }

    public func load(from url: URL, completion: @escaping (PokemonListLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
            case .success((let data, let response)):
                do {
                    let list = try RemotePokemonListMapper.map(data, from: response)
                    completion(.success(list))
                } catch {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
