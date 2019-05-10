//
//  SConfig.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 18/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

class SConfig : NSObject {
    
    open var avatarBubbleImage: AvatarBubbleImageConfig
    open var bubbleImageText: BubbleViewConfig
    open var senderId: String = "0"
    
    private static var instance: SConfig?
    
    private override init() {
        self.avatarBubbleImage = AvatarBubbleImageConfig()
        self.bubbleImageText = BubbleViewConfig()
    }
    
    public static func shared() -> SConfig {
        if SConfig.instance == nil {
            SConfig.instance = SConfig()
        }
        
        return SConfig.instance!
    }
    
    internal class AvatarBubbleImageConfig {
        
        public var isHidden: Bool = false {
            
            willSet {
                print("Will set to: \(newValue)")

                self.size = newValue ? CGSize(width: 4, height: 0) : CGSize(width: 34, height: 30)
                
            }
        }
        
        public var backgroundColor: UIColor? = UIColor.lightGray
        var size: CGSize = CGSize(width: 34, height: 30)
    }
    
    internal class BubbleViewConfig {

        public var color: UIColor?
        public var font: UIFont?
        public var textPadding: UIEdgeInsets?
        
        public var kDefaultBubbleViewOutgoingColor: UIColor = UIColor(withRed: 0.0, green: 122.0, blue: 255.0)
        public var kDefaultBubbleViewIncomingColor: UIColor = UIColor(withRed: 230.0, green: 229.0, blue: 234.0)
        
        public var kDefaultTextIncomingColor: UIColor = UIColor.black
        public var kDefaultTextOutgoingColor: UIColor = UIColor.white
        
        final public var kDefaultCellBottomLabelHeight: CGFloat = 16
        final public var kDefaultCellTopLabelHeight:CGFloat = 16
        final public var kDefaultCellAvatarImageWidth: CGFloat = 30
        final public var kDefaultBubbleMargins: CGFloat = 20
        public var kDefaultImageBubbleSize: CGSize = CGSize(width: 190, height: 160)
        public var kAddFactor:CGFloat = 1.367
        
        public var cellBottomLabelHidden:Bool = false
        
        public var sectionInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 0.0, right: 10.0)
        public var labelInsets = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 24.0, right: 0.0)
        public var textInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        /**
         Instantiate a bubbleView for text with a specified color. The default font will be used. (AvenirNext-Regular)
         */
        init(withColor color: UIColor) {
            self.color = color
        }
        
        /**
         Instantiate a bubbleView for text. The default color and font will be used.
         */
        init() {
            self.color = UIColor.lightGray
        }
    }
    
}
