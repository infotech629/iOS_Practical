//
//  FeedViewModel.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import Foundation

enum FeedViewState {
    case loading
    case loaded([FeedItem])
    case error(String)
}


class FeedViewModel {
    private(set) var state: FeedViewState = .loading
    private(set) var expandedIndices: Set<Int> = []

    private let repository: FeedRepositoryProtocol

    init(repository: FeedRepositoryProtocol = FeedRepository()) {
        self.repository = repository
    }
    @MainActor
    func loadFeed() async {
        state = .loading
        do {
            let items = try await repository.getFeed()
            state = .loaded(items)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func toggleExpanded(at index: Int) {
        if expandedIndices.contains(index) {
            expandedIndices.remove(index)
        } else {
            expandedIndices.insert(index)
        }
    }

    func isExpanded(at index: Int) -> Bool {
        expandedIndices.contains(index)
    }
}
