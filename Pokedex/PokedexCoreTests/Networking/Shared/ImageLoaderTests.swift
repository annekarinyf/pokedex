//
//  ImageLoaderTests.swift
//  PokedexCoreTests
//
//  Created by Anne Kariny Silva Freitas on 13/02/23.
//

import PokedexCore
import XCTest

final class ImageLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSut(url: URL(string: "test-url.com")!)

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageData_requestsDataFromURL() {
        let url = URL(string: "test-url.com")!
        let (sut, client) = makeSut(url: url)
        
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageData_deliversErrorOnClientError() {
        let (sut, client) = makeSut()
        
        expectLoad(sut, toCompleteWithResult: .failure(ImageLoader.Error.connectivity), when: {
            let clientError = NSError(domain: "Error", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_loadImageData_deliversErrorOnNon220HTTPResponse() {
        let statusCodeSamples = [199, 201, 300, 400, 500]
        
        let (sut, client) = makeSut()
        
        statusCodeSamples.enumerated().forEach { index, code in
            expectLoad(sut, toCompleteWithResult: .failure(ImageLoader.Error.invalidData), when:  {
                client.complete(withStatusCode: code, data: anyData(), at: index)
            })
        }
    }
    
    func test_loadImageData_deliversDataOn200HTTPResponse() {
        let (sut, client) = makeSut()
        let data = Data("any image data".utf8)

        expectLoad(sut, toCompleteWithResult: .success(data), when: {
            client.complete(withStatusCode: 200, data: data)
        })
    }

    func test_loadImageData_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: ImageLoader? = ImageLoader(client: client)

        var capturedResults = [ImageLoader.Result]()
        sut?.loadImageData(from: anyURL()) { capturedResults.append($0) }

        sut = nil

        client.complete(withStatusCode: 200, data: anyData())

        XCTAssertTrue(capturedResults.isEmpty)
    }

    @discardableResult
    func makeSut(
        url: URL = URL(string: "test-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: ImageLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ImageLoader(client: client)

        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, client)
    }
    
    func expectLoad(
        _ sut: ImageLoader,
        toCompleteWithResult expectedResult: ImageLoader.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.loadImageData(from: anyURL()) { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem, file: file, line: line)
                
            case let (.failure(receivedError as ImageLoader.Error), .failure(expectedError as ImageLoader.Error)):
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


