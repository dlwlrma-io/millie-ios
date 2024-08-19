//
//  NewsService.swift
//  Millie
//
//  Created by dlwlrma on 8/18/24.
//

import Alamofire
import Combine
import Foundation

class NewsService {
    
    func getHeadlines() -> AnyPublisher<HeadlineResponse, AFError> {
        let apiKey = Bundle.main.infoDictionary?["NEWS_API_KEY"] as! String
        let path = "top-headlines?country=kr&apiKey=\(apiKey)"
        return NetworkManager.shared.request(path: path, method: .get)
    }
}
