//
//  NetworkService.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchFeed() async throws -> [FeedItem]
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchFeed() async throws -> [FeedItem] {
        let url = URL(string: "https://pub-45d7536a85cb49678defa6753b599848.r2.dev/testios/feed.json")!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([FeedItem].self, from: data)
    }
}
