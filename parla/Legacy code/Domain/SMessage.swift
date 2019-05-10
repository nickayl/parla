//
//  SMessage.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 17/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

class SMessage {
    
    var senderId: String
    var senderName: String
    var text: String?
    var date: Date
    var senderAvatar: UIImage?
    var image: UIImage?
    var video: URL?
    var voice: URL?
    var messageType: MessageType = .TextMessage
    
    var senderType: SenderType {
        return senderId == SConfig.shared().senderId ? .Outgoing : .Incoming
    }
    
    /**
        Initialize a SMessage object. Use this init for instantiate a text message. The message is authomatically set as `TextMessage` type.
        - parameter senderId: A unique identifier for the sender of this message.
        - parameter senderName: The name displayed under the message bubble ('cellBottomLabel').
        - parameter text: The text of the message.
        - parameter date: The date of the message, usually displayed at the top label of the message bubble view. ('cellTopLabel')
        - parameter senderAvatar: The avatar image to display at the left (or right) of the bubble message view. Pass `nil` if you don't want to provide an avatar image.
     */
    
    private init(senderId: String, senderName: String, date: Date, senderAvatar: UIImage?)  {
        self.senderId = senderId
        self.senderName = senderName
        self.date = date
        self.senderAvatar = senderAvatar
        
    }
    
    convenience init(senderId: String, senderName: String, text: String, date: Date, senderAvatar: UIImage?) {
        self.init(senderId: senderId, senderName: senderName, date: date, senderAvatar: senderAvatar)
        self.text = text
        self.messageType = .TextMessage
    }
    
    convenience init(senderId: String, senderName: String, image: UIImage, date: Date, senderAvatar: UIImage?) {
        self.init(senderId: senderId, senderName: senderName, date: date, senderAvatar: senderAvatar)
        self.image = image
        self.messageType = .ImageMessage
    }
    
    convenience init(senderId: String, senderName: String, video: URL?, date: Date, senderAvatar: UIImage?) {
        self.init(senderId: senderId, senderName: senderName, date: date, senderAvatar: senderAvatar)
        self.video = video
        self.messageType = .VideoMessage
    }
    
    convenience init(senderId: String, senderName: String, voice: URL?, date: Date, senderAvatar: UIImage?) {
        self.init(senderId: senderId, senderName: senderName, date: date, senderAvatar: senderAvatar)
        self.voice = voice
        self.messageType = .VoiceMessage
    }
    
    
    
}
