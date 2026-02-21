//
//  FeedTableViewCell.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import UIKit
import SDWebImage
import AVFoundation

protocol FeedCellDelegate: AnyObject {
    func feedCell(_ cell: FeedTableViewCell, didRequestExpandForIndex index: Int)
}

class FeedTableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    //MARK: - Variables
    static let identifier = "FeedTableViewCell"
    var playerLayer: AVPlayerLayer?
    var item: FeedItem?
    var cellIndex: Int = 0
    var delegate: FeedCellDelegate?
     //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        pauseVideo()
        item = nil
        profileImageView.image = nil
        thumbnailImageView.image = nil
        descriptionLabel.text = nil
        usernameLabel.text = nil
        timestampLabel.text = nil
        likeLabel.text = nil
        commentLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }

     //MARK: - Function
    func setUpUi(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.height/2
        self.profileImageView.contentMode = .scaleToFill
        self.thumbnailImageView.contentMode = .scaleAspectFill
        self.playButton.layer.cornerRadius = self.playButton.layer.frame.height/2
    }
    
    
    //MARK: - Action
    @IBAction func moreButton(_ sender: UIButton) {
        delegate?.feedCell(self, didRequestExpandForIndex: cellIndex)

    }
    
    @IBAction func playButton(_ sender: UIButton) {
        playVideoIfNeeded()
    }
    
    
    
}
//MARK: - Other Funcion
extension FeedTableViewCell {
    // MARK: - Configuration
    
    func configure(with item: FeedItem, index: Int, isExpanded: Bool) {
        self.item = item
        self.cellIndex = index
        
        self.usernameLabel.text = item.subtitle
        self.timestampLabel.text = item.formattedTimestamp
        self.likeLabel.text = "❤️ \(item.like)"
        self.commentLabel.text = "💬 \(item.commentCount)"
        self.updateDescription(expanded: isExpanded)
        self.loadProfileImage(from: item.thumbnailURL)
        self.loadThumbnail(from: item.thumbnailURL)
        self.pauseVideo()
        self.thumbnailImageView.isHidden = false
        self.playButton.isHidden = false
    }
    
    func updateDescription(expanded: Bool) {
        guard let item = item else { return }
        let maxLines: Int = expanded ? 0 : 3
        let width = max(contentView.bounds.width - 24, UIScreen.main.bounds.width - 48)

        if expanded {
            descriptionLabel.text = item.description
            descriptionLabel.numberOfLines = 0
            moreButton.setTitle("Less", for: .normal)
            moreButton.isHidden = false
        } else {
            descriptionLabel.numberOfLines = maxLines
            descriptionLabel.text = item.description
            let fits = !item.description.needsTruncation(font: descriptionLabel.font ?? .systemFont(ofSize: 14), width: width, maxLines: maxLines)
            moreButton.isHidden = fits
            moreButton.setTitle("More", for: .normal)
        }
    }
    func loadProfileImage(from url: String?) {
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemGray4
        
        guard let url = url else { return }
        profileImageView.sd_setImage(with: URL(string: url))
        
        
    }
    func loadThumbnail(from url: String?) {
        guard let url = url else { return }
        self.thumbnailImageView.sd_setImage(with: URL(string: url))
    }
    // MARK: - Video Playback
    func playVideoIfNeeded() {
        guard let item = item, let url = item.videoURL else { return }

        // Setup player layer if needed
        if playerLayer == nil {
            playerLayer = AVPlayerLayer()
            playerLayer?.videoGravity = .resizeAspectFill
            if let layer = playerLayer {
                videoContainerView.layer.insertSublayer(layer, at: 1)
            }
        }

        playerLayer?.frame = videoContainerView.bounds
        VideoPlayerManager.shared.playVideo(for: url, in: playerLayer!)

        thumbnailImageView.isHidden = true
        playButton.isHidden = true
    }
    func pauseVideo() {
        VideoPlayerManager.shared.pauseVideo()
        playerLayer?.removeFromSuperlayer()
        playerLayer?.player = nil
        playerLayer = nil
        thumbnailImageView.isHidden = false
        playButton.isHidden = false
    }

    var feedItemVideoURL: URL? {
        item?.videoURL
    }


}
