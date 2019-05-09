//
//  ParlaConfig.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import UIKit

public class Parla {
    
    public var sender: PSender
    public var avatarSize: CGSize = CGSize(width: 34, height: 30)
    
    // Bubble color
    final public var kDefaultBubbleViewOutgoingColor: UIColor = UIColor(withRed: 0.0, green: 122.0, blue: 255.0)
    final public var kDefaultBubbleViewIncomingColor: UIColor = UIColor(withRed: 230.0, green: 229.0, blue: 234.0)
    
    public var containerViewController: UIViewController!
    
    public let kDefaultTextIncomingColor = UIColor.black
    public let kDefaultTextOutgoingColor = UIColor.white
    
    public let kDefaultCellBottomLabelHeight: CGFloat = 16
    public let kDefaultCellTopLabelHeight:CGFloat = 16
    public let kDefaultCellAvatarImageWidth: CGFloat = 30
    public let kDefaultBubbleMargins: CGFloat = 20
    public let kDefaultImageBubbleSize: CGSize = CGSize(width: 170, height: 150)
    public let kAddFactor:CGFloat = 1.367
    
    public var cellBottomLabelHidden:Bool = false
    public var isAvatarHidden = false
    public var avatarBackgroundColor = UIColor.lightGray

    public let kDefaultTextFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
    
    
    public var sectionInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 0.0, right: 10.0)
    public var labelInsets = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 24.0, right: 0.0)
    public var textInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    public static var config: Parla!
    
    init(withSender sender: PSender) {
        self.sender = sender
    }
}
