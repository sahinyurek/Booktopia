//
//  Book.swift
//  Book Finder
//
//  Created by Şahin Yürek on 4/2/23.
//

import Foundation

struct SearchResult: Codable {
    let kind: String
    let totalItems: Int
    let items: [BookItem]

    enum CodingKeys: String, CodingKey {
        case kind
        case totalItems
        case items
    }
}

struct BookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo

    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
    }
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?

    enum CodingKeys: String, CodingKey {
        case title
        case authors
        case publisher
        case publishedDate
        case description
        case imageLinks
    }
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case smallThumbnail
        case thumbnail
    }
}
