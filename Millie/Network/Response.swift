//
//  Response.swift
//  Millie
//
//  Created by dlwlrma on 8/19/24.
//

import Foundation

struct HeadlineResponse: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Codable {
    var source: Source
    var author: String
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
}

struct Source: Codable {
    var id: String
    var name: String
}
