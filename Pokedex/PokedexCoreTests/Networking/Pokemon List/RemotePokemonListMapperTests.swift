//
//  RemotePokemonListMapperTests.swift
//  PokedexCoreTests
//
//  Created by Anne Kariny Silva Freitas on 13/02/23.
//

import PokedexCore
import XCTest

final class RemotePokemonListMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJSONValues([:])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try RemotePokemonListMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try RemotePokemonListMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversItemOn200HTTPResponseWithJSONItem() throws {
        let list = PokemonList.fixture()
        let json = makeJSONValues(makeJSON(list: list))
        
        let result = try RemotePokemonListMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, list)
    }
}

