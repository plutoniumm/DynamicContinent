//
//  APIService.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/03/2025.
//

import Foundation

class APIService {
    
    enum HTTPMethod: String {
        case GET
    }
    
    enum HTTPError: Error {
        case invalidURL
        case decodingFailed
        case noData
    }
    
    static let shared = APIService()
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        
        return URLSession(
            configuration: config,
            delegate: nil,
            delegateQueue: .main
        )
    }()
    
    private init() { }
    
    private func createRequest(
        method: HTTPMethod,
        url: URL,
        headers: [String: String] = [:],
        parameters: [String: Any] = [:]
    ) -> URLRequest {
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10
        )
        
        request.httpMethod = method.rawValue
        
        return request
    }
    
    func get<T: Codable>(
        url: URL?,
        onComplete: @escaping (Result<T, Error>) -> Void
    ) -> T? {
        guard let url = url else {
            onComplete(
                .failure(
                    HTTPError.invalidURL
                )
            )
            return nil
        }
        
        let request = self.createRequest(
            method: .GET,
            url: url
        )
        
        self.session.dataTask(
            with: request
        ) { data, urlResponse, error in
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    
                    onComplete(
                        .success(object)
                    )
                } catch let error {
                    print(error)
                    onComplete(
                        .failure(
                            error
                        )
                    )
                }
                
                return
            }
            
            if let error = error {
                onComplete(
                    .failure(error)
                )
                
                return
            }
            
            onComplete(
                .failure(
                    HTTPError.noData
                )
            )
        }.resume()
        
        return nil
    }
    
}
