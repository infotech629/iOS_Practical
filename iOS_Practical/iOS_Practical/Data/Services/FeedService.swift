//
//  FeedService.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import Foundation

protocol FeedServiceProtocol {
    func getFeed() async throws -> [FeedItem]
}
class FeedService: FeedServiceProtocol {
    private let repository: FeedRepositoryProtocol

    init(repository: FeedRepositoryProtocol = FeedRepository()) {
        self.repository = repository
    }

    func getFeed() async throws -> [FeedItem] {
        try await repository.getFeed()
    }
}
