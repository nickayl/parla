//
//  AbstractBubble.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 29/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import CoreGraphics

class AbstractBubble: NSObject {
    
    public var isAvatarImageHidden: Bool = false
    public var isCellTopLabelVisible: Bool = true
    public var isCellBottomLabelVisible: Bool = true
    public var bubbleSize: CGSize
    public var message: SMessage?
    
    init(size: CGSize, message: SMessage) {
        self.bubbleSize = size
        self.message = message
    }
}
