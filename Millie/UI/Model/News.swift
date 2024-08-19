//
//  News.swift
//  Millie
//
//  Created by dlwlrma on 8/19/24.
//

import Foundation

struct News: Hashable {
    var author: String
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
}
