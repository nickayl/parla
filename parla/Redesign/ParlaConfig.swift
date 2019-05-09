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
    
    var sender: PSender
    var avatarSize: CGSize = CGSize(width: 0, height: 0)
    
    public let kDefaultBubbleViewIncomingColor = UIColor.lightGray
    public let kDefaultBubbleViewOutgoingColor = UIColor.blue
    public let kDefaultTextIncomingColor = UIColor.black
    public let kDefaultTextOutgoingColor = UIColor.white
    
    public let kDefaultCellBottomLabelHeight: CGFloat = 16
    public let kDefaultCellTopLabelHeight:CGFloat = 16
    public let kDefaultCellAvatarImageWidth: CGFloat = 30
    public let kDefaultBubbleMargins: CGFloat = 20
    public let kDefaultImageBubbleSize: CGSize = CGSize(width: 190, height: 160)
    public let kAddFactor:CGFloat = 1.367
    
    public var cellBottomLabelHidden:Bool = false

    public let kDefaultTextFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
    
    
    public var sectionInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 0.0, right: 10.0)
    public var labelInsets = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 24.0, right: 0.0)
    public var textInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    public static var config: Parla!
    
    init(withSender sender: PSender) {
        self.sender = sender
    }
}
