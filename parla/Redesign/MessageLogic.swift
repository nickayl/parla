//
//  SMessage.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 17/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit


let incomingTextMessageXibName = "IncomingTextMessageCell", incomingTextMessageReuseIdentifier = "BubbleCellViewIDTextIncomingXib"
let outgoingTextMessageXibName = "OutgoingTextMessageCell", outgoingTextMessageReuseIdentifier = "BubbleCellViewIDTextOutgoingXib"
let incomingImageMessageXibName = "IncomingImageMessageCell", incomingImageMessageReuseIdentifier = "BubbleCellViewIDImageIncomingXib"
let outgoingImageMessageXibName = "OutgoingImageMessageCell", outgoingImageMessageReuseIdentifier = "BubbleCellViewIDImageOutgoingXib"
let incomingVoiceMessageXibName = "VoiceMessageCell", incomingVoiceMessageReuseIdenfitier = "BubbleCellViewIDVoiceIncomingXib"

public protocol PMessage {
    var messageId: Int { get set }
    var date: Date { get set }
    var sender: PSender { get set }
    var messageType: MessageType { get }
    var senderType: SenderType { get }
    var cellIdentifier: String { get }
}

public protocol PTextMessage : PMessage {
    var text: String { get set }
    var enableCopyOnLongTouch: Bool { get set }
    init(id: Int, sender: PSender, text: String, date: Date)
}

public protocol PImageMessage : PMessage {
    var image: UIImage { get set }
    var viewController: UIViewController! { get set }
    var viewer: ImageViewer { get set }
    func show()
    func hide()
    init(id: Int, sender: PSender, image: UIImage, date: Date)
}

public class PImageMessageImpl: AbstractPMessage<UIImage>, PImageMessage {
    
    public var image: UIImage
    public var viewer: ImageViewer
    
    public var viewController: UIViewController!
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingImageMessageReuseIdentifier : outgoingImageMessageReuseIdentifier
    }
    
    public required init(id: Int, sender: PSender, image: UIImage, date: Date) {
        self.image = image
        self.viewer = SKPhotoBrowserImageViewer(withImage: image, withViewController: viewController)
        super.init(id: id, sender: sender, date: date, type: .ImageMessage)
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
    
    public var enableCopyOnLongTouch: Bool = true {
        willSet {
            if newValue && label != nil {
                label?.canCopyText = true
            } else {
                print("WARNING ==> CANNOT COPY TEXT WITHOUT AN ASSIGNED UIPaddingLabel. Please use the correct initializer. <== ")
            }
        }
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
    
    // var text: String?
    //    var image: UIImage?
    //    var video: URL?
    //    var voice: URL?
    
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


