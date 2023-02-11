//
//  ImageLoader.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public final class ImageLoader: ImageDataLoader {
    private let client: HTTPClient
    private let cache = Cache<URL, Data>()
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidData
        case connectivity
    }
    
    public func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else {
                return
            }
            
            if let cached = self?.cache[url] {
                return completion(.success(cached))
            }
            
            completion(Result {
                switch result {
                case .success((let data, let response)):
                    guard response.isOK else {
                        throw Error.invalidData
                    }
                    self?.cache[url] = data
                    return data
                    
                case .failure:
                    throw Error.connectivity
                }
            })
        }
    }
}
