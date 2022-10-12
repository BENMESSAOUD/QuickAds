//
//  QuickAdsTests.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import XCTest
@testable import QuickAds

class NetworkServiceTests: XCTestCase {
    let urlSession = MockedURLSession()
    
    //MARK: - Unit Test
    func test_performRequest_should_FailWithUnknownError_when_CodeStatusNotDetermined() async throws {
        //given
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        urlSession.behaviour = .data(Data(), URLResponse())
        
        let networkService = NetworkService(urlSession: urlSession)
        
        //when
        let result = try await networkService.fetchAds()
        
        //then
        XCTAssertEqual(result, .failure(.unknown))
    }

    func test_performRequest_should_FailWithBadRequestError_when_CodeStatusIs400() async throws {
        //given
        let urlResponse = HTTPURLResponse(
            url: URL(string: "https://anyUrl.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        urlSession.behaviour = .data(Data(), urlResponse!)
        let networkService = NetworkService(urlSession: urlSession)
        
        //when
        let result = try await networkService.fetchAds()
        
        //then
        XCTAssertEqual(result, .failure(.badRequest))
    }
    
    func test_performRequest_should_FailWithRequestNotFoundError_when_CodeStatusIs404() async throws {
        //given
        let urlResponse = HTTPURLResponse(
            url: URL(string: "https://anyUrl.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        urlSession.behaviour = .data(Data(), urlResponse!)
        let networkService = NetworkService(urlSession: urlSession)
        
        //when
        let result = try await networkService.fetchAds()
        
        //then
        XCTAssertEqual(result, .failure(.requestNotFound))
    }
    
    func test_performRequest_should_FailWithServerError_when_CodeStatusIs5xx() async throws {
        //given
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        let urlResponse = HTTPURLResponse(
            url: URL(string: "https://anyUrl.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        urlSession.behaviour = .data(Data(), urlResponse!)
        let networkService = NetworkService(urlSession: urlSession)
        
        //when
        let result = try await networkService.fetchAds()
        
        //then
        XCTAssertEqual(result, .failure(.serverError))
    }
    
    func test_performRequest_should_FailWithUnknownError_when_CodeStatusIsNotHandled() async throws {
        //given
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        let urlResponse = HTTPURLResponse(
            url: URL(string: "https://anyUrl.com")!,
            statusCode: 1000,
            httpVersion: nil,
            headerFields: nil
        )
        urlSession.behaviour = .data(Data(), urlResponse!)
        let networkService = NetworkService(urlSession: urlSession)
        
        //when
        let result = try await networkService.fetchAds()
        
        //then
        XCTAssertEqual(result, .failure(.statusCodeNotHandled))
    }
    
    func test_performRequest_should_FailWithJSONError_when_DataIsEmpty() async throws {
        //given
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        let urlResponse = HTTPURLResponse(
            url: URL(string: "https://anyUrl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        urlSession.behaviour = .data(Data(), urlResponse!)
        let networkService = NetworkService(urlSession: urlSession)
        
        //when
        let result = try await networkService.fetchAds()
        
        //then
        XCTAssertEqual(result, .failure(.badJSONFormat))
    }
    
    func test_performRequest_should_FailWithJSONError_when_DataCouldNotBeParsed() async throws {
        //given
        let urlResponse = HTTPURLResponse(
            url: URL(string: "https://anyUrl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let jsonString = "{\"result\": 3}"
        let data = jsonString.data(using: .utf8)!
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        urlSession.behaviour = .data(data, urlResponse!)
        let networkService = NetworkService(urlSession: urlSession)
        
        //when
        let result = try await networkService.fetchAds()
        
        //then
        XCTAssertEqual(result, .failure(.badJSONFormat))
    }
    
    func test_performRequest_should_Success_when_StatusCodeIs200_AND_DataIsParsable() async throws {
        //given
        let urlResponse = HTTPURLResponse(
            url: URL(string: "https://anyUrl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let jsonString = """
        [{
            "id": 1,
            "name": "Véhicule"
          },
          {
            "id": 2,
            "name": "Mode"
          }]
        """
        let data = jsonString.data(using: .utf8)!
        let urlCache = MockedURLCache()
        urlCache.cachedResponseBehaviour = .null
        urlSession.cache = urlCache
        urlSession.behaviour = .data(data, urlResponse!)
        let networkService = NetworkService(urlSession: urlSession)
        let expectedCategories = [
            Category(id: 1, name: "Véhicule"),
            Category(id: 2, name: "Mode")
        ]
        
        //when
        let result = try await networkService.fetchAdsCategories()
        
        //then
        XCTAssertEqual(result, .success(expectedCategories))
    }


    // MARK: - Integration Test
    func test_FetchAds_RealCall() async throws {
        urlSession.behaviour = .realCall
        let networkService = NetworkService(urlSession: urlSession)
        let fetchAdsResult = try await networkService.fetchAds()
        switch fetchAdsResult {
        case .success(let ads):
            XCTAssertNotNil(ads)
        case .failure(let error):
            XCTFail("Fetch Ads is not working.\nReason: \(error)")
        }
    }
    
    func test_FetchCategories_RealCall() async throws {
        urlSession.behaviour = .realCall
        let networkService = NetworkService(urlSession: urlSession)
        let fetchAdsResult = try await networkService.fetchAdsCategories()
        switch fetchAdsResult {
        case .success(let categories):
            XCTAssertNotNil(categories)
        case .failure(let error):
            XCTFail("Fetch Category is not working.\nReason: \(error)")
        }
    }
}
