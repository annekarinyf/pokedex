//
//  RemotePokemonListLoaderTests.swift
//  PokedexCoreTests
//
//  Created by Anne Kariny Silva Freitas on 13/02/23.
//

import PokedexCore
import XCTest

final class RemotePokemonListLoaderTests: XCTestCase {
    typealias Error = RemotePokemonListLoader.Error
    
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
        let list = PokemonList.fixture()
        let json = makeJSON(list: list)

        expectLoad(sut, toCompleteWithResult: .success(list), when: {
            let json = makeJSONValues(json)
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: PokemonListLoader? = RemotePokemonListLoader(client: client)

        var capturedResults = [RemotePokemonListLoader.Result]()
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
    ) -> (sut: RemotePokemonListLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonListLoader(client: client)

        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, client)
    }
    
    func expectLoad(
        _ sut: RemotePokemonListLoader,
        toCompleteWithResult expectedResult: PokemonListLoader.Result,
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
    func makeJSON(list: PokemonList) -> [String: Any] {
        let items = list.items.reduce(into: [String: String]()) { $0["url"] = $1.url.absoluteString }
        let json: [String: Any?] = [
            "next": list.nextURL?.absoluteString ?? "",
            "results": [items]
        ]
        
        return json.compactMapValues { $0 }
    }
}

extension PokemonList {
    static func fixture(
        nextURL: URL = anyURL(),
        items: [PokemonListItem] = [.fixture()]
    ) -> PokemonList {
        PokemonList(
            nextURL: nextURL,
            items: items
        )
    }
}

extension PokemonListItem {
    static func fixture(
        url: URL = anyURL()
    ) -> PokemonListItem {
        PokemonListItem(url: url)
    }
}
