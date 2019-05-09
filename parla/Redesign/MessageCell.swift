//
//  MessageCell.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class TextMessageCell : AbstractMessageCell {
    
    @IBOutlet var textLabel: UIPaddingLabel!
    var message: PTextMessage!
    
    override func getSize() -> CGSize {
        
        /*** ----- CONSTANTS --- ***/
        let avatarSize = Parla.config.avatarSize
        let cfg = Parla.config!
        /*** ------------------- ***/
        
        /*** ----- VARIABLES --- ***/
        var leadingOrTrailingConstraint: NSLayoutConstraint
        var bubbleColor = cfg.kDefaultBubbleViewIncomingColor
        
        /*** ------------------- ***/
        
        if message.sender.type == .Incoming {
            leadingOrTrailingConstraint = cellTrailingConstraint
            bubbleColor = cfg.kDefaultBubbleViewIncomingColor
        } else {
            leadingOrTrailingConstraint = cellLeadingConstraint
            bubbleColor = cfg.kDefaultBubbleViewOutgoingColor
        }
        
        var cellWidth = frame.width
        
        textLabel.textColor = cfg.kDefaultTextIncomingColor
        
        if message.senderType == .Outgoing {
            textLabel.textColor = cfg.kDefaultTextOutgoingColor
        }
        
        textLabel.backgroundColor = bubbleColor
        textLabel.padding = cfg.textInsets
        textLabel.text = message.text
        textLabel.setBorderRadius(radius: 19)
        
        let textWidth = ceil(NSAttributedString(string: message.text).size().width) + (cfg.textInsets.left + cfg.textInsets.right)
        
        print("tw \(textWidth) cw \(cellWidth) sendertype: \(message.senderType.rawValue)")
        
        if cellWidth > ((textWidth * cfg.kAddFactor) + avatarSize.width + cfg.kDefaultBubbleMargins) {
            var bubbleWidth = (textWidth * cfg.kAddFactor)
            bubbleWidth = bubbleWidth < 38 ? 38 : bubbleWidth
            print("bubble text width: \(bubbleWidth) original text width: \(textWidth)")
            leadingOrTrailingConstraint.constant = cellWidth - (bubbleWidth + avatarSize.width)
            textLabel.textAlignment = .center
            textLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            leadingOrTrailingConstraint.constant = (cfg.labelInsets.left * 2)+cfg.kDefaultBubbleMargins
            textLabel.textAlignment = .left
            textLabel.padding = cfg.textInsets
        }
        
        
        let cellPaddingSpace = cfg.sectionInsets.left + cfg.sectionInsets.right
        cellWidth -= cellPaddingSpace
        
        var bubbleHeight: CGFloat = CGFloat(48.0)
        
        let bubbleWidth = cellWidth - ((cfg.labelInsets.left + cfg.labelInsets.right) + (cfg.textInsets.left + cfg.textInsets.right) + avatarSize.width + cfg.kDefaultBubbleMargins)
        let baseHeight = CGFloat(48.0)
        
        bubbleHeight = ceil(message.text.height(with: bubbleWidth, font: cfg.kDefaultTextFont)) + (cfg.labelInsets.top + cfg.labelInsets.bottom)
        
        bubbleHeight = bubbleHeight < baseHeight ? baseHeight : bubbleHeight
            
        return CGSize(width: cellWidth, height: bubbleHeight)
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
    
    var viewController: ParlaViewController!
    var indexPath: IndexPath!
    
    func getSize() -> CGSize {
        // To be overridden
        return CGSize(width: 0, height: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Awake from nib")
    }
    
}
