//
//  BubbleTextViewHolder.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 29/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class BubbleImageViewHolder : ViewHolder  {
    
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
        /*** ------------------- ***/
        
        cell.indexPath = indexPath
        
        if message.senderType == SenderType.Incoming {
            leadingOrTrailingConstraint = cell.bubbleTrailingConstraint
            bubbleColor = cfg.kDefaultBubbleViewIncomingColor
        } else {
            leadingOrTrailingConstraint = cell.bubbleLeadingConstraint
            bubbleColor = cfg.kDefaultBubbleViewOutgoingColor
        }
        
        let cellWidth = cell.frame.width
        leadingOrTrailingConstraint.constant = cellWidth - (cfg.kDefaultImageBubbleSize.width + config.avatarBubbleImage.size.width)
        
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
        
        if message.messageType == .VideoMessage {
           /* cell.bubbleImage.layer.sublayers?.removeAll()
            
            let myLayer = CALayer()
            myLayer.contentsGravity = kCAGravityCenter
            myLayer.isGeometryFlipped = true
            
            var rect: CGRect = cell.bubbleImage.frame
            rect.size = cfg.kDefaultImageBubbleSize
            myLayer.frame = rect
            
            let myLayer2 = CALayer()
            myLayer2.frame = rect
            myLayer2.backgroundColor = UIColor.black.cgColor
            myLayer2.opacity = 0.6
            
            myLayer.contents = UIImage(named: "play2")?.cgImage
            
            cell.bubbleImage.layer.addSublayer(myLayer2)
            cell.bubbleImage.layer.addSublayer(myLayer) */
            cell.blackBackgroundVideoView.isHidden = false
            
           
            if let url = message.video {
                DispatchQueue.global(qos: .userInitiated).async {
                    let thumbnailImage = Utils.thumbnailImageForVideo(withUrl: url, atTime: 1)
                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            cell.bubbleImage.image = thumbnailImage
                            message.image = thumbnailImage
                        }
                }
            } else {
                print("video nil")
            }

        } else {
            cell.blackBackgroundVideoView.isHidden = true
            cell.bubbleImage.image = message.image!
        }
        
        cell.bubbleImage.setBorderRadius(radius: 13)
        cell.blackBackgroundVideoView.setBorderRadius(radius: 13)
        
       // if let _ = cell.bubbleImage.gestureRecognizers {
         //   cell.bubbleImage.addGestureRecognizer(UITapGestureRecognizer(target: cell.bubbleImage, action: #selector(self.showImage(_:))))
        //}
        
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
