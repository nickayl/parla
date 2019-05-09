//
//  SMessage.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 17/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit


let incomingTextMessageXibName = "IncomingTextMessageCell", incomingTextMessageReuseIdentifier = "TextIncomingXib"
let outgoingTextMessageXibName = "OutgoingTextMessageCell", outgoingTextMessageReuseIdentifier = "TextOutgoingXib"
let incomingImageMessageXibName = "IncomingImageMessageCell", incomingImageMessageReuseIdentifier = "ImageIncomingXib"
let outgoingImageMessageXibName = "OutgoingImageMessageCell", outgoingImageMessageReuseIdentifier = "ImageOutgoingXib"
let incomingVoiceMessageXibName = "VoiceMessageCell", incomingVoiceMessageReuseIdenfitier = "VoiceIncomingXib"
let outgoingVideoMessageXibName = "OutgoingVideoMessageCell", outgoingVideoMessageReuseIdentifier = "VideoOutgoingXib"
let incomingVideoMessageXibName = "IncomingVideoMessageCell", incomingVideoMessageReuseIdentifier = "VideoIncomingXib"

public protocol PMessage {
    var messageId: Int { get set }
    var date: Date { get set }
    var sender: PSender { get set }
    var messageType: MessageType { get }
    var senderType: SenderType { get }
    var cellIdentifier: String { get }
    func displaySize(frameWidth: CGFloat) -> CGSize
    
    func triggerSelection()
}

public protocol PTextMessage : PMessage {
    var text: String { get set }
    var enableCopyOnLongTouch: Bool { get set }
    init(id: Int, sender: PSender, text: String, date: Date)
}

public protocol PVideoMessage : PMessage {
    var thumbnail: UIImage? { get set }
    var videoUrl: URL { get set }
    var duration: Float? { get set }
    var player: VideoPlayer? { get set }
    init(id: Int, sender: PSender, videoUrl: URL, thumbnail: UIImage?, date: Date)
}

public protocol PImageMessage : PMessage {
    var image: UIImage { get set }
  //  var viewController: UIViewController! { get set }
    var viewer: ImageViewer { get set }
    func show()
    func hide()
    init(id: Int, sender: PSender, image: UIImage, date: Date)
}

public class PVideoMessageImpl : AbstractPMessage<URL>, PVideoMessage {
    
    public var thumbnail: UIImage?
    public var videoUrl: URL
    public var duration: Float?
    public var player: VideoPlayer?
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingVideoMessageReuseIdentifier : outgoingVideoMessageReuseIdentifier
    }
    
    required public init(id: Int, sender: PSender, videoUrl: URL, thumbnail: UIImage? = nil, date: Date = Date()) {
        self.videoUrl = videoUrl
        self.thumbnail = thumbnail
        super.init(id: id, sender: sender, date: date, type: .VideoMessage)
        
        self.player = MobilePlayerVideoPlayer(with: self)
    }
    
    public override func triggerSelection() {
        player?.play()
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config!
        return CGSize(width: frameWidth - (cfg.sectionInsets.left + cfg.sectionInsets.right), height: 160)
    }
}

public class PImageMessageImpl: AbstractPMessage<UIImage>, PImageMessage {
    
    public var image: UIImage
    public var viewer: ImageViewer
    
   // public var viewController: UIViewController!
    private let viewController = Parla.config!.containerViewController!
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingImageMessageReuseIdentifier : outgoingImageMessageReuseIdentifier
    }
    
    public required init(id: Int, sender: PSender, image: UIImage, date: Date) {
        self.image = image
        self.viewer = SKPhotoBrowserImageViewer(withImage: image, withViewController: viewController)
        super.init(id: id, sender: sender, date: date, type: .ImageMessage)
    }
    
    public override func triggerSelection() {
        show()
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
//        let size = Parla.config!.kDefaultImageBubbleSize
//        print("returning \(size) from image message displaySize")
//        return size
        let cfg = Parla.config!
        return CGSize(width: frameWidth - (cfg.sectionInsets.left + cfg.sectionInsets.right), height: 160)
    }
    
    public func show() {
        self.viewer.show()
    }
    
    public func hide() {
        self.viewer.hide()
    }
    
}

public class PTextMessageImpl : AbstractPMessage<String>, PTextMessage {
    
    public var text: String
    private var label: UIPaddingLabel?
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingTextMessageReuseIdentifier : outgoingTextMessageReuseIdentifier
    }
    
    required public init(id: Int, sender: PSender, text: String, date: Date = Date()) {
        self.text = text
        super.init(id: id, sender: sender, date: date, type: .TextMessage)
        self.content = text
    }
    
    convenience init(id: Int, sender: PSender, text: String, date: Date = Date(), label: UIPaddingLabel) {
        self.init(id: id, sender: sender, text: text, date: date)
        self.label = label
        self.label?.canCopyText = enableCopyOnLongTouch
    }

    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config!
        var cellWidth = frameWidth
        let avatarSize = self.sender.avatar != nil ? cfg.avatarSize : CGSize(width: 0, height: 0)
        
        let cellPaddingSpace = cfg.sectionInsets.left + cfg.sectionInsets.right
        cellWidth -= cellPaddingSpace
        
        let bubbleWidth = cellWidth - ((cfg.labelInsets.left + cfg.labelInsets.right) + (cfg.textInsets.left + cfg.textInsets.right) + avatarSize.width + cfg.kDefaultBubbleMargins)
        
        let baseHeight = CGFloat(56.0)
        var bubbleHeight = baseHeight
        
        if(self.text.count > 60 || self.text.contains("\n")) {
            bubbleHeight = ceil(text.height(with: bubbleWidth, font: cfg.kDefaultTextFont)) + (cfg.labelInsets.top + cfg.labelInsets.bottom)
            bubbleHeight = bubbleHeight < baseHeight ? baseHeight : bubbleHeight
        }
        
        return CGSize(width: cellWidth, height: bubbleHeight)
    }
    
    public var enableCopyOnLongTouch: Bool = true {
        willSet {
            if newValue && label != nil {
                label?.canCopyText = true
            } else {
                print("WARNING ==> CANNOT COPY TEXT WITHOUT AN ASSIGNED UIPaddingLabel. Please use the correct initializer. <== ")
            }
        }
    }
    
    public override func triggerSelection() {
        print("TextMessage does nothing when is tapped")
    }
    
    
    
}

public class AbstractPMessage<T> : PMessage, Equatable, Comparable {
    
    public var messageId: Int = 0
    public var date: Date
    public var sender: PSender
    public var messageType: MessageType
    public var content: T?
    
    public var senderType: SenderType {
        return sender == Parla.config.sender ? .Outgoing : .Incoming
    }

    public var cellIdentifier: String {
        return ""
    }
    
    public func displaySize(frameWidth: CGFloat) -> CGSize {
        return CGSize(width: 50, height: 38)
    }
    
    public func triggerSelection() {
        print("This message does nothing on selection")
    }
    
    fileprivate init(id: Int, sender: PSender, date: Date = Date(), type: MessageType) {
        self.messageId = id
        self.date = date
        self.sender = sender
        self.messageType = type
    }
    
    public static func == (lhs: AbstractPMessage, rhs: AbstractPMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    public static func < (lhs: AbstractPMessage, rhs: AbstractPMessage) -> Bool {
        return lhs.date.compare(rhs.date).rawValue < 0
    }
    
}


