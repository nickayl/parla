//
//  BubbleTextViewHolder.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 29/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

class BubbleTextViewHolder : ViewHolder  {
    
    typealias T = BubbleViewCell
    
    private var bubbleView: AbstractBubble
    private var config: SConfig = SConfig.shared()
    private var indexPath: IndexPath
    
    init(indexPath: IndexPath, bubbleView: AbstractBubble) {
        self.bubbleView = bubbleView
        self.indexPath = indexPath
    }
    
    func getView(rCell: UICollectionViewCell) -> BubbleViewCell {
        
        /*** ----- CONSTANTS --- ***/
        let cell: BubbleViewCell = rCell as! BubbleViewCell
        let message = bubbleView.message!
        let avatarSize = config.avatarBubbleImage.size
        let cfg = config.bubbleImageText
        /*** ------------------- ***/
        
        /*** ----- VARIABLES --- ***/
        var leadingOrTrailingConstraint: NSLayoutConstraint
        var bubbleColor: UIColor = cfg.kDefaultBubbleViewIncomingColor
        var bubbleTextColor: UIColor = cfg.kDefaultTextIncomingColor
        /*** ------------------- ***/
        
        cell.indexPath = indexPath
        
        if message.senderType == SenderType.Incoming {
            leadingOrTrailingConstraint = cell.bubbleTrailingConstraint
            bubbleColor = cfg.kDefaultBubbleViewIncomingColor
            bubbleTextColor = cfg.kDefaultTextIncomingColor
        } else {
            leadingOrTrailingConstraint = cell.bubbleLeadingConstraint
            bubbleColor = cfg.kDefaultBubbleViewOutgoingColor
            bubbleTextColor = cfg.kDefaultTextOutgoingColor
        }
        
        cell.textLabel.textColor = bubbleTextColor
        cell.textLabel.backgroundColor = bubbleColor
        
        cell.textLabel.padding = cfg.textInsets
        cell.textLabel.text = message.text!
        cell.textLabel.setBorderRadius(radius: 19)
        
        let textWidth = ceil(NSAttributedString(string: message.text!).size().width) + (cfg.textInsets.left + cfg.textInsets.right)
        let cellWidth = cell.frame.width
        
        print("tw \(textWidth) cw \(cellWidth) sendertype: \(message.senderType.rawValue)")
        
        if cellWidth > ((textWidth * cfg.kAddFactor) + avatarSize.width + cfg.kDefaultBubbleMargins) {
            var bubbleWidth = (textWidth * cfg.kAddFactor)
            bubbleWidth = bubbleWidth < 38 ? 38 : bubbleWidth
            print("bubble text width: \(bubbleWidth) original text width: \(textWidth)")
            leadingOrTrailingConstraint.constant = cellWidth - (bubbleWidth + avatarSize.width)
            cell.textLabel.textAlignment = .center
            cell.textLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            leadingOrTrailingConstraint.constant = (cfg.labelInsets.left * 2)+cfg.kDefaultBubbleMargins
            cell.textLabel.textAlignment = .left
            cell.textLabel.padding = cfg.textInsets
        }
        
        if indexPath.item % 4 != 0 {
            cell.cellTopLabelHeightContraint.constant = 0
        } else {
            cell.cellTopLabelHeightContraint.constant = cfg.kDefaultCellTopLabelHeight
        }
        
        if self.config.avatarBubbleImage.isHidden {
            cell.cellAvatarImageWidthConstraint.constant = 0
            
        } else {
            cell.cellAvatarImageWidthConstraint.constant = cfg.kDefaultCellAvatarImageWidth
        }
        
        cell.avatarBubbleImage.setBorderRadius(radius: Int(cell.avatarBubbleImage.frame.width/2))
        cell.avatarBubbleImage.image = UIImage(withBackground: UIColor.lightGray)
        
        if let img = message.senderAvatar {
            cell.avatarBubbleImage.image = img
        }
        
        if cfg.cellBottomLabelHidden {
            cell.cellBottomLabelHeightConstraint.constant = 0
        } else {
            cell.cellBottomLabelHeightConstraint.constant = cfg.kDefaultCellBottomLabelHeight
            cell.bottomLabel.text = message.senderName
        }
        
        
        if message.senderType == SenderType.Incoming {
            cell.bubbleTrailingConstraint.constant = leadingOrTrailingConstraint.constant
            cell.bottomLabel.padding = UIEdgeInsets(top: 0, left: avatarSize.width + 5, bottom: 0, right: 0)
        } else {
            cell.bubbleLeadingConstraint.constant = leadingOrTrailingConstraint.constant
            cell.bottomLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: avatarSize.width + 10)
        }
        
        return cell

        
    }
    
    
}
