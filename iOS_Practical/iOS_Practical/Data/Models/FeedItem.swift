//
//  FeedItem.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//
import Foundation

struct FeedItem: Codable, Identifiable, Hashable {
    let id: String
    let description: String
    let sources: [String]
    let subtitle: String
    let thumb: String
    let title: String
    let timeAt: String
    let like: Int
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case description, sources, subtitle, thumb, title, like
        case timeAt = "time_at"
        case commentRaw = "commment"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let sources = try container.decode([String].self, forKey: .sources)
        id = "\(title)-\(sources.first ?? "")"

        description = try container.decode(String.self, forKey: .description)
        self.sources = sources
        subtitle = try container.decode(String.self, forKey: .subtitle)
        thumb = try container.decode(String.self, forKey: .thumb)
        self.title = title
        timeAt = try container.decode(String.self, forKey: .timeAt)
        like = try container.decode(Int.self, forKey: .like)

        // API returns comment as either Int or String
        if let intValue = try? container.decode(Int.self, forKey: .commentRaw) {
            commentCount = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .commentRaw),
                  let parsed = Int(stringValue) {
            commentCount = parsed
        } else {
            commentCount = 0
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(sources, forKey: .sources)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(thumb, forKey: .thumb)
        try container.encode(title, forKey: .title)
        try container.encode(timeAt, forKey: .timeAt)
        try container.encode(like, forKey: .like)
        try container.encode(commentCount, forKey: .commentRaw)
    }

    var videoURL: URL? {
        guard let firstSource = sources.first else { return nil }
        return URL(string: firstSource)
    }

    var thumbnailURL: String? {
        let baseURL = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/\(thumb)"
        return baseURL
    }

    var formattedTimestamp: String {
        if let timestamp = Double(timeAt) {
            let date = Date(timeIntervalSince1970: timestamp)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return timeAt
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }
}
