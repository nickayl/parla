//
//  SSender.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 18/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

@objc public enum SenderType : Int {
    case Incoming, Outgoing
}

@objc public class PSender : NSObject {

    public var id: Int
    public var name: String
    public var avatar: PAvatar
    public var type: SenderType
    
    public init(senderId: Int, senderName: String, avatar: PAvatar?, type: SenderType) {
        self.id = senderId
        self.name = senderName
        self.avatar = avatar ?? PAvatar.void
        self.type = type
    }
    
    public static func == (lhs: PSender, rhs: PSender) -> Bool {
        return lhs.id == rhs.id
    }
    
}

public class PAvatar {
    
    var image: UIImage
    var size: CGSize
    public static let void = PAvatar()
    
    public init(withImage image: UIImage) {
        self.image = image
        self.size = Parla.config.avatar.size
    }
    
    private init() {
        self.size = CGSize.zero
        self.image = UIImage(withBackground: Parla.config.avatar.backgroundColor)
    }
    
}
