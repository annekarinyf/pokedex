//
//  ImageDataLoader.swift
//  PokedexCore
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

public protocol ImageDataLoader {
    typealias Result = Swift.Result<Data?, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}
