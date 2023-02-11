//
//  RemotePokemonDetailLoader.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public protocol PokemonDetailLoader {
    typealias Result = Swift.Result<PokemonDetail, Error>
    func load(from url: URL, completion: @escaping (PokemonDetailLoader.Result) -> Void)
}

public final class RemotePokemonDetailLoader: PokemonDetailLoader {
    private let client: HTTPClient
    private let cache = Cache<URL, PokemonDetail>()

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(client: HTTPClient) {
        self.client = client
    }

    public func load(from url: URL, completion: @escaping (PokemonDetailLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else {
                return
            }
        
            if let cached = self?.cache[url] {
                return completion(.success(cached))
            }
            
            switch result {
            case .success((let data, let response)):
                do {
                    let detail = try RemotePokemonDetailMapper.map(data, from: response)
                    self?.cache[url] = detail
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
