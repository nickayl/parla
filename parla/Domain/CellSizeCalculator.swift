//
//  BubbleSizeCalculator.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 29/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class CellSizeCalculator {
    
    private var config: SConfig = SConfig.shared()
    private var view: UIView
    private var textFont: UIFont
    
    init(mainView view: UIView, textFont: UIFont) {
        self.view = view
        self.textFont = textFont
    }
    
    public func bubbleSizeForItemAt(indexPath: IndexPath, withMessage m: SMessage) -> CGSize {
        
        let cfg = config.bubbleImageText
        
        let cellPaddingSpace = cfg.sectionInsets.left + cfg.sectionInsets.right
        let cellWidth = view.frame.width - cellPaddingSpace
        let avatarSize = self.config.avatarBubbleImage.size
        var bubbleHeight: CGFloat = CGFloat(48.0)
        
        if m.messageType  == .TextMessage {
            let bubbleWidth = cellWidth - ((cfg.labelInsets.left + cfg.labelInsets.right) + (cfg.textInsets.left + cfg.textInsets.right) + avatarSize.width + cfg.kDefaultBubbleMargins)
            let baseHeight = CGFloat(48.0)
            
            bubbleHeight = ceil(m.text!.height(with: bubbleWidth, font: textFont)) + (cfg.labelInsets.top + cfg.labelInsets.bottom)
            
            bubbleHeight = bubbleHeight < baseHeight ? baseHeight : bubbleHeight

        } else if m.messageType == .ImageMessage || m.messageType == .VideoMessage {
            bubbleHeight = cfg.kDefaultImageBubbleSize.height + cfg.kDefaultCellTopLabelHeight + cfg.kDefaultCellBottomLabelHeight
        } else {
            bubbleHeight = 72.0
        }
        
        // for cell top label
        if indexPath.item % 4 != 0 {
            bubbleHeight -= cfg.kDefaultCellTopLabelHeight
        }
        
        // for cell bottom label
        if cfg.cellBottomLabelHidden && m.senderType == .Outgoing {
            bubbleHeight -= cfg.kDefaultCellBottomLabelHeight
        }
        
        let size = CGSize(width: cellWidth, height: bubbleHeight)
        print("Size: \(size)")
        return size

    }
    
}
