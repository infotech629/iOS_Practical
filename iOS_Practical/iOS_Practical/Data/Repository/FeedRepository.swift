//
//  FeedRepository.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import Foundation

protocol FeedRepositoryProtocol {
    func getFeed() async throws -> [FeedItem]
}

class FeedRepository: FeedRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getFeed() async throws -> [FeedItem] {
        return try await networkService.fetchFeed()
    }
}
