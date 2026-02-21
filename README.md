# iOS Practical

An iOS Feed application that displays a vertical scrollable feed of video posts, similar to social media feeds. Built with Swift and UIKit using MVVM architecture.

## Features

- **Video Feed** – Vertical feed of video posts with thumbnails
- **Auto-play** – Centered visible video plays automatically; others pause on scroll
- **Expandable Description** – "More" / "Less" to toggle full description text
- **Pull to Refresh** – Swipe down to reload feed data
- **Image Loading** – Profile and thumbnail images via SDWebImage
- **Error Handling** – User-friendly alerts for network errors
- **Empty State** – NoDataFound cell when feed is empty

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Tech Stack

| Layer       | Technology              |
|------------|--------------------------|
| UI         | UIKit, Storyboards, XIBs |
| Video      | AVFoundation             |
| Networking | URLSession, async/await  |
| Images     | SDWebImage 5.21.6        |
| Architecture | MVVM, Repository Pattern |

## Project Structure

```
iOS_Practical/
├── AppDelegate/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── ViewController/
│   └── FeedViewController.swift
├── ViewModel/
│   └── FeedViewModel.swift
├── Data/
│   ├── Models/
│   │   └── FeedItem.swift
│   ├── Repository/
│   │   └── FeedRepository.swift
│   └── Services/
│       └── FeedService.swift
├── Networking/
│   └── NetworkService.swift
├── Player/
│   └── VideoPlayerManager.swift
├── TableViewCell/
│   ├── FeedTableViewCell.swift
│   ├── FeedTableViewCell.xib
│   ├── NoDataFoundTableViewCell.swift
│   └── NoDataFoundTableViewCell.xib
├── Extensions/
│   ├── String+Ext.swift
│   └── UIView+Ext.swift
└── Storyboard/
    └── Base.lproj/
        ├── Main.storyboard
        └── LaunchScreen.storyboard
```

## Architecture

- **MVVM** – `FeedViewModel` manages state (`loading`, `loaded`, `error`) and business logic
- **Repository** – `FeedRepository` abstracts data source; `NetworkService` fetches from API
- **VideoPlayerManager** – Singleton to manage single active `AVPlayer`, attach/detach from cells
- **Protocols** – `FeedRepositoryProtocol`, `NetworkServiceProtocol`, `FeedServiceProtocol` for testability

## API

Feed data is fetched from:

```
https://pub-45d7536a85cb49678defa6753b599848.r2.dev/testios/feed.json
```

### FeedItem Model

| Field        | Type     | Description                 |
|-------------|----------|-----------------------------|
| id          | String   | Unique identifier           |
| title       | String   | Post title                  |
| description | String   | Post description            |
| subtitle    | String   | Username / subtitle         |
| thumb       | String   | Thumbnail path              |
| sources     | [String] | Video URLs                  |
| time_at     | String   | Unix timestamp              |
| like        | Int      | Like count                  |
| commment    | Int/Str  | Comment count               |

## Setup

1. Clone the repository
2. Open `iOS_Practical.xcodeproj` in Xcode
3. Build and run (⌘R)

Dependencies (SDWebImage) are managed via Swift Package Manager and will resolve automatically.

## Key Components

### FeedViewController

- TableView with `FeedTableViewCell` and `NoDataFoundTableViewCell`
- Pull-to-refresh and loading states
- Scroll delegate to detect centered cell and trigger video play/pause
- `FeedCellDelegate` for expand/collapse description

### VideoPlayerManager

- Single `AVPlayer` instance shared across cells
- Plays video only in the cell closest to screen center
- Detaches from previous layer when switching cells
- Configures `AVAudioSession` for `.playback` mode

### FeedItem

- Codable model with custom `CodingKeys` for API (`time_at`, `commment`)
- Handles both Int and String for comment count
- Computed `videoURL`, `thumbnailURL`, `formattedTimestamp`

## License

MIT
