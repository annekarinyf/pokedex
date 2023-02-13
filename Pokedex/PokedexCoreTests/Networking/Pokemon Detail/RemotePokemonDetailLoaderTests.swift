//
//  RemotePokemonDetailLoaderTests.swift
//  PokedexCoreTests
//
//  Created by Anne Kariny Silva Freitas on 13/02/23.
//

import PokedexCore
import XCTest

final class RemotePokemonDetailLoaderTests: XCTestCase {
    typealias Error = RemotePokemonDetailLoader.Error
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSut(url: URL(string: "test-url.com")!)

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "test-url.com")!
        let (sut, client) = makeSut(url: url)
        
        sut.load(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "test-url.com")!
        let (sut, client) = makeSut(url: url)
        
        sut.load(from: url) { _ in }
        sut.load(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSut()
        
        expectLoad(sut, toCompleteWithResult: .failure(Error.connectivity), when: {
            let clientError = NSError(domain: "Error", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon220HTTPResponse() {
        let statusCodeSamples = [199, 201, 300, 400, 500]
        
        let (sut, client) = makeSut()
        
        statusCodeSamples.enumerated().forEach { index, code in
            expectLoad(sut, toCompleteWithResult: .failure(Error.invalidData), when:  {
                let json = makeJSONValues([:])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSut()
        
        expectLoad(sut, toCompleteWithResult: .failure(Error.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversItemOn200HTTPResponseWithJSONItem() {
        let (sut, client) = makeSut()
        let detail = PokemonDetail.fixture()
        let json = makeJSON(detail: detail)

        expectLoad(sut, toCompleteWithResult: .success(detail), when: {
            let json = makeJSONValues(json)
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: PokemonDetailLoader? = RemotePokemonDetailLoader(client: client)

        var capturedResults = [RemotePokemonDetailLoader.Result]()
        sut?.load(from: anyURL()) { capturedResults.append($0) }

        sut = nil

        client.complete(withStatusCode: 200, data: makeJSONValues([:]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    @discardableResult
    func makeSut(
        url: URL = URL(string: "test-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemotePokemonDetailLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonDetailLoader(client: client)

        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, client)
    }
    
    func expectLoad(
        _ sut: RemotePokemonDetailLoader,
        toCompleteWithResult expectedResult: PokemonDetailLoader.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(from: anyURL()) { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem, file: file, line: line)
                
            case let (.failure(receivedError as Error), .failure(expectedError as Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}

extension XCTestCase {
    func makeJSON(detail: PokemonDetail) -> [String: Any] {
        let typesDict = detail.types.reduce(into: [String: String]()) { $0["name"] = $1.rawValue }
        let types: [String: Any] = [
            "type": typesDict
        ]
        var stats = [[String: Any]] ()
        detail.stats.forEach { stat in
            var dict = [String: Any]()
            dict["base_stat"] = stat.baseStat
            dict["stat"] = ["name": stat.name]
            stats.append(dict)
        }
        
        let json: [String: Any?] = [
            "id": detail.id,
            "name": detail.name,
            "weight": detail.weight,
            "height": detail.height,
            "types": [types],
            "stats": stats,
            "base_experience": detail.baseExperience,
            "sprites": [ "front_default": detail.spriteURL.absoluteString ]
        ]
        
        return json.compactMapValues { $0 }
    }
}

extension PokemonDetail {
    static func fixture(
        id: Int = Int.random(in: 0...100),
        name: String = .random(),
        weight: Float = .random(in: 0...100),
        height: Float = .random(in: 0...100),
        types: [PokemonType] = [.unknown],
        stats: [Stat] = [.fixture()],
        baseExperience: Int = Int.random(in: 0...100),
        spriteURL: URL = anyURL()
    ) -> PokemonDetail {
        PokemonDetail(
            id: id,
            name: name,
            weight: weight,
            height: height,
            types: types,
            stats: stats,
            baseExperience: baseExperience,
            spriteURL: spriteURL
        )
    }
}

extension PokemonDetail.Stat {
    static func fixture(
        name: String = .random(),
        baseStat: Int = Int.random(in: 0...100)
    ) -> PokemonDetail.Stat {
        PokemonDetail.Stat(
            name: name,
            baseStat: baseStat
        )
    }
}
