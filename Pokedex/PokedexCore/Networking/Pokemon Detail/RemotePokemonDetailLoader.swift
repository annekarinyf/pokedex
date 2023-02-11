//
//  RemotePokemonDetailLoader.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public protocol PokemonDetailLoader {
    typealias Result = Swift.Result<PokemonDetail, Error>
    func load(completion: @escaping (PokemonDetailLoader.Result) -> Void)
}

public final class RemotePokemonDetailLoader: PokemonDetailLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (PokemonDetailLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
            case .success((let data, let response)):
                do {
                    let detail = try RemotePokemonDetailMapper.map(data, from: response)
                    completion(.success(detail))
                } catch {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
