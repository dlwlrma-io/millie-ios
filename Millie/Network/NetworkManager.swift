//
//  NetworkManager.swift
//  Millie
//
//  Created by dlwlrma on 8/18/24.
//

import Alamofire
import Combine
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private var baseUrl: String = "https://newsapi.org/v2/"
    
    func request<T: Codable>(path: String, method: HTTPMethod) -> AnyPublisher<T, AFError> {
        let url = URL(string: self.baseUrl + path)!
        
        return AF.request(url,method: method, encoding: JSONEncoding.default)
            .publishDecodable(type: T.self)
            .value()
            .mapError { error in
                print(error.localizedDescription)
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
