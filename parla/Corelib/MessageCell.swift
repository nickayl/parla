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
        container.backgroundColor = message.backgroundColor
        message.player?.delegate = self
        
        let cellWidth = frame.width
        leadingOrTrailingConstraint.constant = cellWidth - (cfg.cell.kDefaultVoiceMessageWidth + message.sender.avatar.size.width)
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
        
        leadingOrTrailingConstraint.constant = cellWidth - (cfg.cell.kDefaultVideoBubbleSize.width + message.sender.avatar.size.width)
        
        blackBackgroundVideoView.isHidden = false
        imageView.setBorderRadius(radius: 16)
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

class ImageMessageCell: AbstractMessageCell, PMessageDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
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
        
        leadingOrTrailingConstraint.constant = cellWidth - (cfg.cell.kDefaultImageBubbleSize.width + message.sender.avatar.size.width)
    
        self.message.delegate = self
        
        if self.message.isReadyToUse {
            imageView.image = self.message.image
        } else {
            self.activityIndicator.startAnimating()
        }
        
        imageView.setBorderRadius(radius: 16)

        addDefaultTapGestureRecognizer()
        addDefaultLongTouchGestureRecognizer()
        
        if message.options.isTopLabelActive {
            self.topLabel.text = message.imageDescription
            self.topLabel.textAlignment = (message.sender.type == .Incoming ? .left : .right)
        }
        
    }
    
    func messageIsReadyToBeConsumed(message: PMessage) {
        self.activityIndicator.stopAnimating()
        self.viewController.collectionView.scrollToBottom(animated: true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.alpha = 0
        }) { _ in
            self.imageView.image = self.message.image
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
            self.imageView.alpha = 1
            self.topLabel.text = (message as? PMapMessage)?.address ?? self.topLabel.text
        }, completion: nil)
        
      //  self.viewController.refreshCollection(animated: true)
    }
    //        imageView.addGestureRecognizer(
    //            UITapGestureRecognizer(target: self, action: #selector(bubbleImageSelected(sender:)))
    //  )
//    @objc func bubbleImageSelected(sender: UITapGestureRecognizer) {
//        viewController.parlaDelegate?.didTapMessageBubble(at: indexPath, message: self.message, collectionView: viewController.collectionView)
//    }
    
}



class TextMessageCell : AbstractMessageCell {
    
    @IBOutlet var textLabel: UIPaddingLabel!
    @IBOutlet var textLabelHeightConstraint: NSLayoutConstraint!
    
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
        let avatarSize = self.message.sender.avatar.size
        let cellWidth = frame.width
        
        textLabelHeightConstraint.constant = frame.size.height - CGFloat(cellTopLabelHeightContraint.constant + cellBottomLabelHeightConstraint.constant)
        textLabel.textColor = message.contentColor
        textLabel.backgroundColor = message.backgroundColor
        textLabel.padding = cfg.cell.textInsets
        textLabel.text = message.text
        textLabel.setBorderRadius(radius: 19)
        
        let textWidth = ceil(NSAttributedString(string: message.text).size().width) + (cfg.cell.textInsets.left + cfg.cell.textInsets.right)
        
    //    print("tw \(textWidth) cw \(cellWidth) sendertype: \(message.senderType.rawValue)")
        let kAddFactor:CGFloat = 1.367
        
        if cellWidth > ((textWidth * kAddFactor) + avatarSize.width + cfg.cell.kDefaultBubbleMargins) {
            var bubbleWidth = (textWidth * kAddFactor)
            bubbleWidth = bubbleWidth < 38 ? 38 : bubbleWidth
         //   print("bubble text width: \(bubbleWidth) original text width: \(textWidth)")
            leadingOrTrailingConstraint.constant = cellWidth - (bubbleWidth + avatarSize.width)
            textLabel.textAlignment = .center
            textLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            textLabel.setBorderRadius(radius: 19)
        } else {
//            leadingOrTrailingConstraint.constant = (cfg.cell.labelInsets.left * 2)+cfg.cell.kDefaultBubbleMargins
            leadingOrTrailingConstraint.constant = cfg.cell.kDefaultBubbleMargins + Parla.config.avatar.size.width
            textLabel.textAlignment = .left
            textLabel.padding = cfg.cell.textInsets
        }
        
        addDefaultTapGestureRecognizer()
        addDefaultLongTouchGestureRecognizer()
        
        (self.message as? PTextMessageImpl)?.label = textLabel
        
        self.message.enableCopyOnLongTouch = true
        
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
    @IBOutlet var cellAvatarImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var cellTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var cellLeadingConstraint: NSLayoutConstraint!
    
    var leadingOrTrailingConstraint: NSLayoutConstraint!
    var viewController: ParlaView!
    var indexPath: IndexPath!
    var content: PMessage? {
        get { return nil }
        set { }
    }
    
    let cfg = Parla.config
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initialize() {
        
        if content?.sender.type == .Incoming {
            leadingOrTrailingConstraint = cellTrailingConstraint
        } else {
            leadingOrTrailingConstraint = cellLeadingConstraint
        }
        
        let top = content?.options.isTopLabelActive ?? false ? Parla.config.cell.topLabelHeight : 0
        let bottom = content?.options.isBottomLabelActive ?? false ? Parla.config.cell.bottomLabelHeight : 0
        
        cellTopLabelHeightContraint.constant = CGFloat(top)
        cellBottomLabelHeightConstraint.constant = CGFloat(bottom)
        
        if bottom > 0 {
            self.bottomLabel.text = self.content?.sender.name
            self.bottomLabel.textAlignment = (content?.sender.type == .Incoming ? .left : .right)
            
            if self.content?.sender.type == .Incoming {
                //   cellTrailingConstraint.constant = leadingOrTrailingConstraint.constant
                bottomLabel.padding = UIEdgeInsets(top: 0, left: cfg.cell.textInsets.left, bottom: 0, right: 0)
            } else {
                //  cellLeadingConstraint.constant = leadingOrTrailingConstraint.constant
                bottomLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:cfg.cell.textInsets.right)
            }
        }
        
        let avatarSize = content?.sender.avatar.size ?? CGSize.zero
        
        cellAvatarImageWidthConstraint.constant = avatarSize.width
        cellAvatarImageHeightConstraint.constant = avatarSize.height
        
        if !avatarSize.equalTo(CGSize.zero) {
            // If the sender have an avatar image let's set it. Otherwise it'll be replaced with a custom background color
            self.avatarBubbleImage.contentMode = Parla.config.avatar.imageContentMode
            avatarBubbleImage.image = content?.sender.avatar.image
            avatarBubbleImage.setBorderRadius(radius: Int(avatarSize.width / 2))
        }
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
     //   print("prepare for reuse")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    //    print("Awake from nib")
    //    self.bubbleColor = cfg.cell.kDefaultBubbleViewIncomingColor
    }
    
    final fileprivate func addDefaultTapGestureRecognizer() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMessage(_:))))
    }
    
    final fileprivate func addDefaultLongTouchGestureRecognizer() {
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongTouchMessage(_:))))
    }
    
    @objc final fileprivate func didTapMessage(_ sender: UITapGestureRecognizer) {
        self.viewController.delegate?.didTapMessageBubble(at: indexPath, message: content!, collectionView: viewController.collectionView)
    }
    
    @objc final fileprivate func didLongTouchMessage(_ sender: UITapGestureRecognizer) {
        self.viewController.delegate?.didLongTouchMessage?(at: indexPath, message: content!, collectionView: viewController.collectionView)
    }
    
}
