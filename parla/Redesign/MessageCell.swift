//
//  MessageCell.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation

import UIKit
import AVKit

class VoiceMessageCell : AbstractMessageCell, PAudioPlayerDelegate {
    
    var message: PVoiceMessage!
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var container: UIView!
    
    private lazy var playImage = UIImage(named: "play100")
    private lazy var pauseImage = UIImage(named: "pause100")
    
    override var content: PMessage? {
        get { return message }
        
        set {
            if let v = newValue as? PVoiceMessage {
                self.message = v
            }
        }
    }
    
    override func initialize() {
        super.initialize()
        
        container.setBorderRadius(radius: 20)
        message.player?.delegate = self
        
        let cellWidth = frame.width
        leadingOrTrailingConstraint.constant = cellWidth - (cfg.kDefaultVoiceMessageWidth + cfg.avatarSize.width)
        print("Current progrtess: \(message.player?.currentProgress) / \(message.duration)")
        
        if message.duration > 0 {
            progressView.progress = self.message?.player?.currentProgress ?? 0
        } else {
            progressView.progress = 0
        }
        
        addDefaultTapGestureRecognizer()
        addDefaultLongTouchGestureRecognizer()
        
    }
    
    @IBAction func onPlayPauseButtonPressed(_ sender: UIButton) {
        message.player?.toggle()
    }
    
    public func didStartPlayingAudio(with url: URL?, atSecondsFromStart: Int, wasInPause: Bool) {
        print("Did start playing audio")
        playPauseButton.isSelected = true
        if !wasInPause {
            progressView.progress = 0
        }
      //  playPauseButton.setImage(pauseImage, for: .selected)
    }
    
    public func didStopPlayingAudio(with url: URL?, atSecondsFromStart: Int, pause: Bool) {
        print("Did stop playing audio")
        playPauseButton.isSelected = false
        if !pause {
            progressView.progress = 1.0
        }
      //  playPauseButton.setImage(playImage, for: .normal)
    }
    
    public func audioCurrentlyPlayingWith(currentTime time: Float, totalDuration duration: Float) {
        print("audio playing: \(time) \(duration)")
        progressView.progress = time/duration
    }
    
    
    
}

class VideoMessageCell : AbstractMessageCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var blackBackgroundVideoView: UIView!
    
    var message: PVideoMessage! {
        didSet {
            self.imageView.image = message.thumbnail
        }
    }
    
    override var content: PMessage? {
        get { return message }
        
        set {
            if let v = newValue as? PVideoMessage {
                self.message = v
            }
        }
    }
    
    override func initialize() {
        super.initialize()

        let cellWidth = frame.width
        
        leadingOrTrailingConstraint.constant = cellWidth - (cfg.kDefaultImageBubbleSize.width + cfg.avatarSize.width)
        
        blackBackgroundVideoView.isHidden = false
        imageView.setBorderRadius(radius: 13)
        blackBackgroundVideoView.setBorderRadius(radius: 13)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let thumbnailImage = Utils.thumbnailImageForVideo(withUrl: self.message.videoUrl, atTime: 1)
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.imageView.image = thumbnailImage
                self.message.thumbnail = thumbnailImage
            }
        }
        
//        imageView.addGestureRecognizer(
//            UITapGestureRecognizer(target: self, action: #selector(videoSelected(sender:)))
//        )
        addDefaultTapGestureRecognizer()
        addDefaultLongTouchGestureRecognizer()
        
    }
    
//    @objc func videoSelected(sender: UITapGestureRecognizer) {
//        viewController.parlaDelegate?.didTapMessageBubble(at: indexPath, message: self.message, collectionView: viewController.collectionView)
//    }
    
}

class ImageMessageCell: AbstractMessageCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var message: PImageMessage! {
        didSet {
            self.imageView.image = message.image
        }
    }
    
    override var content: PMessage? {
        get { return message }
        
        set {
            if let v = newValue as? PImageMessage {
                self.message = v
            }
        }
    }
    
    override func initialize() {
        super.initialize()

        let cellWidth = frame.width
        
        leadingOrTrailingConstraint.constant = cellWidth - (cfg.kDefaultImageBubbleSize.width + cfg.avatarSize.width)
    
        imageView.image = self.message.image
        imageView.setBorderRadius(radius: 13)

        addDefaultTapGestureRecognizer()
        addDefaultLongTouchGestureRecognizer()
        
//        imageView.addGestureRecognizer(
//            UITapGestureRecognizer(target: self, action: #selector(bubbleImageSelected(sender:)))
      //  )
    }
    
//    @objc func bubbleImageSelected(sender: UITapGestureRecognizer) {
//        viewController.parlaDelegate?.didTapMessageBubble(at: indexPath, message: self.message, collectionView: viewController.collectionView)
//    }
    
}



class TextMessageCell : AbstractMessageCell {
    
    @IBOutlet var textLabel: UIPaddingLabel!
    
    var message: PTextMessage! {
        didSet {
            self.textLabel.text = message.text
        }
    }
    
    override var content: PMessage? {
        get { return message }
        
        set {
            if let v = newValue as? PTextMessage {
                self.message = v
            }
        }
    }
    
    override func initialize() {
        super.initialize()
        
        //let avatarSize = Parla.config.avatarSize
        let avatarSize = self.message.sender.avatar == nil ? CGSize(width: 0, height: 0) : cfg.avatarSize
        let cellWidth = frame.width
        
        textLabel.textColor = cfg.kDefaultTextIncomingColor
        
        if message.senderType == .Outgoing {
            textLabel.textColor = cfg.kDefaultTextOutgoingColor
        }
        
        textLabel.backgroundColor = bubbleColor
        textLabel.padding = cfg.textInsets
        textLabel.text = message.text
        textLabel.setBorderRadius(radius: 19)
        
        let textWidth = ceil(NSAttributedString(string: message.text).size().width) + (cfg.textInsets.left + cfg.textInsets.right)
        
    //    print("tw \(textWidth) cw \(cellWidth) sendertype: \(message.senderType.rawValue)")
        
        if cellWidth > ((textWidth * cfg.kAddFactor) + avatarSize.width + cfg.kDefaultBubbleMargins) {
            var bubbleWidth = (textWidth * cfg.kAddFactor)
            bubbleWidth = bubbleWidth < 38 ? 38 : bubbleWidth
         //   print("bubble text width: \(bubbleWidth) original text width: \(textWidth)")
            leadingOrTrailingConstraint.constant = cellWidth - (bubbleWidth + avatarSize.width)
            textLabel.textAlignment = .center
            textLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            textLabel.setBorderRadius(radius: 19)
        } else {
            leadingOrTrailingConstraint.constant = (cfg.labelInsets.left * 2)+cfg.kDefaultBubbleMargins
            textLabel.textAlignment = .left
            textLabel.padding = cfg.textInsets
        }
        
        addDefaultTapGestureRecognizer()
        addDefaultLongTouchGestureRecognizer()
        
        (self.message as? PTextMessageImpl)?.label = textLabel
        
        self.message.enableCopyOnLongTouch = false
        
    }
    
    override func awakeFromNib() {
        print("Awake from nib")
    }
}

class AbstractMessageCell: UICollectionViewCell {
    
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UIPaddingLabel!
    @IBOutlet var avatarBubbleImage: UIImageView!
    
    @IBOutlet var cellTopLabelHeightContraint: NSLayoutConstraint!
    @IBOutlet var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cellAvatarImageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var cellTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var cellLeadingConstraint: NSLayoutConstraint!
    
    var leadingOrTrailingConstraint: NSLayoutConstraint!
    var viewController: ParlaViewController!
    var indexPath: IndexPath!
    var content: PMessage? {
        get { return nil }
        set { }
    }
    
    let cfg = Parla.config!
    var bubbleColor: UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initialize() {
        // To be overridden
        
        if content?.sender.type == .Incoming {
            leadingOrTrailingConstraint = cellTrailingConstraint
            bubbleColor = cfg.kDefaultBubbleViewIncomingColor
        } else {
            leadingOrTrailingConstraint = cellLeadingConstraint
            bubbleColor = cfg.kDefaultBubbleViewOutgoingColor
        }
        
        // Hide the Top label every 4 items.
//        if indexPath.item % 4 != 0 {
//            self.content?.isDateLabelActive = false
//            cellTopLabelHeightContraint.constant = 0
//        } else {
//            self.content?.isDateLabelActive = true
//            cellTopLabelHeightContraint.constant = cfg.kDefaultCellTopLabelHeight
//        }
        // ---
        
        if self.content?.isDateLabelActive ?? false {
            cellTopLabelHeightContraint.constant = cfg.kDefaultCellTopLabelHeight
        } else {
            cellTopLabelHeightContraint.constant = 0
        }
        
        // If the avatar hidden option is true, let's hide the Avatar . Otherwise show it with default values
        if cfg.isAvatarHidden || self.content?.sender.avatar?.image == nil {
            cellAvatarImageWidthConstraint.constant = 0
            self.avatarBubbleImage.frame.size = CGSize(width: 0, height: 0)
            
        } else {
            cellAvatarImageWidthConstraint.constant = cfg.kDefaultCellAvatarImageWidth
            avatarBubbleImage.setBorderRadius(radius: Int(avatarBubbleImage.frame.width/2))
            
            // If the sender have an avatar image let's set it. Otherwise it'll be replaced with a custom background color
            if let img = viewController.parlaDataSource.sender.avatar?.image {
                avatarBubbleImage.image = img
            } else {
                avatarBubbleImage.image = UIImage(withBackground: cfg.avatarBackgroundColor)
            }
        }

        // Hide or show the bottom label of the cell.
        if cfg.cellBottomLabelHidden {
            cellBottomLabelHeightConstraint.constant = 0
        } else {
            cellBottomLabelHeightConstraint.constant = cfg.kDefaultCellBottomLabelHeight
            bottomLabel.text = self.content?.sender.name
        }
        
        
        if self.content?.sender.type == .Incoming {
         //   cellTrailingConstraint.constant = leadingOrTrailingConstraint.constant
            bottomLabel.padding = UIEdgeInsets(top: 0, left: cfg.textInsets.left, bottom: 0, right: 0)
        } else {
          //  cellLeadingConstraint.constant = leadingOrTrailingConstraint.constant
            bottomLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:cfg.textInsets.right)
        }
        
        self.avatarBubbleImage.image = self.content?.sender.avatar?.image
      //  return CGSize(width: 0, height: 0)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
     //   print("prepare for reuse")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    //    print("Awake from nib")
        self.bubbleColor = cfg.kDefaultBubbleViewIncomingColor
    }
    
    final fileprivate func addDefaultTapGestureRecognizer() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMessage(_:))))
    }
    
    final fileprivate func addDefaultLongTouchGestureRecognizer() {
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongTouchMessage(_:))))
    }
    
    @objc final fileprivate func didTapMessage(_ sender: UITapGestureRecognizer) {
        self.viewController.parlaDelegate?.didTapMessageBubble(at: indexPath, message: content!, collectionView: viewController.collectionView)
    }
    
    @objc final fileprivate func didLongTouchMessage(_ sender: UITapGestureRecognizer) {
        self.viewController.parlaDelegate?.didLongTouchMessage(at: indexPath, message: content!, collectionView: viewController.collectionView)
    }
    
}
