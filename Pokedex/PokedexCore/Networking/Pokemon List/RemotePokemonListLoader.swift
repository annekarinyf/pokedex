//
//  RemotePokemonListLoader.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public protocol PokemonListLoader {
    typealias Result = Swift.Result<PokemonItem, Error>
    func load(completion: @escaping (PokemonListLoader.Result) -> Void)
}

public final class RemotePokemonListLoader: PokemonListLoader {
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

    public func load(completion: @escaping (PokemonListLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
            case .success((let data, let response)):
                do {
                    let weather = try WeatherInformationMapper.map(data, from: response)
                    completion(.success(weather))
                } catch {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
