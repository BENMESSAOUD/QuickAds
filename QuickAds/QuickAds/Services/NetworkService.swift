//
//  NetworkService.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchAds() async throws -> Result<[ClassifiedAd], NetworkError>
    func fetchAdsCategories() async throws -> Result<[Category], NetworkError>
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

enum NetworkError: Error {
    case wrongURLFormat
    case badJSONFormat
    case badRequest
    case requestNotFound
    case serverError
    case statusCodeNotHandled
    case unknown
}

final class NetworkService {

    enum Path: String {
        case listing = "/listing.json"
        case categories = "/categories.json"
    }
    private let schemes = "https://"
    private let host = "raw.githubusercontent.com"
    private let baseURL = "/leboncoin/paperclip/master"
    private let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    private let decoder: JSONDecoder
    private let urlSession: URLSessionProtocol
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    init(decoder: JSONDecoder = JSONDecoder(), urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    private func url(for path: Path) -> URL? {
        URL(string: schemes+host+baseURL+path.rawValue)
    }
    
    private func performRequest<T: Decodable>(path: Path) async throws -> Result<T, NetworkError> {
        guard let url = url(for: path) else { return .failure(.wrongURLFormat) }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return .failure(.unknown) }
        
        switch statusCode {
        case 200...203:
            do {
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
            } catch {
                return .failure(.badJSONFormat)
            }
        case 400:
            return .failure(.badRequest)
        case 404:
            return .failure(.requestNotFound)
        case 500...599:
            return .failure(.serverError)
        default:
            return .failure(.statusCodeNotHandled)
        }
    }
}

extension NetworkService: NetworkServiceProtocol {
    func fetchAds() async throws -> Result<[ClassifiedAd], NetworkError> {
        try await performRequest(path: .listing)
    }
    
    func fetchAdsCategories() async throws -> Result<[Category], NetworkError> {
        try await performRequest(path: .categories)
    }
}

extension URLSession: URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, *) {
            return try await data(from: url, delegate: nil)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                let task = self.dataTask(with: url) { data, response, error in
                    guard let data = data, let response = response else {
                        let error = error ?? URLError(.badServerResponse)
                        return continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: (data, response))
                }
                task.resume()
            }
        }
    }
}
