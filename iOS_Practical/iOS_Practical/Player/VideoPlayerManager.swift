//
//  VideoPlayerManager.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import AVFoundation
import UIKit

class VideoPlayerManager {
    static let shared = VideoPlayerManager()

    private var player: AVPlayer?
    private var currentLayer: AVPlayerLayer?
    private var currentURL: URL?

    private init() {

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        } catch {

        }
    }

    func playVideo(for url: URL, in layer: AVPlayerLayer) {
    
        if currentURL == url && currentLayer == layer {
            player?.play()
            return
        }

        detachFromCurrentLayer()

        currentURL = url
        currentLayer = layer

        if let existingPlayer = player,
           let asset = existingPlayer.currentItem?.asset as? AVURLAsset,
           asset.url == url {
            layer.player = existingPlayer
            existingPlayer.seek(to: .zero)
            existingPlayer.play()
        } else {
            player = AVPlayer(url: url)
            layer.player = player
            player?.play()
        }
    }

    func pauseVideo() {
        player?.pause()
        detachFromCurrentLayer()
        currentLayer = nil
    }

    private func detachFromCurrentLayer() {
        currentLayer?.player = nil
        currentLayer = nil
    }

    func isPlaying(url: URL) -> Bool {
        currentURL == url && player?.rate != 0
    }

    func clearCurrentContext() {
        player?.pause()
        detachFromCurrentLayer()
        currentURL = nil
        currentLayer = nil
    }
}
