//
//  CellBubble.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 22/02/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class CellBubble : NSObject {
    
    private var cellSize: CGSize!
    private var bubbleSize: CGSize!
    private var indexPath: IndexPath!
    private var config : CellBubbleConfig
    
    private var message: SMessage
    
    init(message: SMessage, indexPath: IndexPath, config: CellBubbleConfig?) {
        self.indexPath = indexPath
        self.message = message
        
        self.config = config ?? CellBubbleConfig()
    }
    
    
    @objc func fillCellView(reusableCell: UICollectionViewCell) -> BubbleViewCell {
        
        /*** ----- CONSTANTS --- ***/
        let cell: BubbleViewCell = reusableCell as! BubbleViewCell
        let avatarSize = config.avatarSize
        let cfg = config
        /*** ------------------- ***/
        
        /*** ----- VARIABLES --- ***/
        var leadingOrTrailingConstraint: NSLayoutConstraint
        var bubbleColor: UIColor = cfg.kDefaultBubbleViewIncomingColor
        
        /*** ------------------- ***/
        
        if message.senderType == SenderType.Incoming {
            leadingOrTrailingConstraint = cell.bubbleTrailingConstraint
            bubbleColor = cfg.kDefaultBubbleViewIncomingColor
        } else {
            leadingOrTrailingConstraint = cell.bubbleLeadingConstraint
            bubbleColor = cfg.kDefaultBubbleViewOutgoingColor
        }
        
        let cellWidth = cell.frame.width
        
        if message.messageType == .TextMessage {
            
            cell.textLabel.textColor = cfg.kDefaultTextIncomingColor
            
            if message.senderType == .Outgoing {
                cell.textLabel.textColor = cfg.kDefaultTextOutgoingColor
            }
            cell.textLabel.backgroundColor = bubbleColor
            cell.textLabel.padding = cfg.textInsets
            cell.textLabel.text = message.text!
            cell.textLabel.setBorderRadius(radius: 19)
            
            let textWidth = ceil(NSAttributedString(string: message.text!).size().width) + (cfg.textInsets.left + cfg.textInsets.right)
            
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
        } else if message.messageType == .ImageMessage {
            
            leadingOrTrailingConstraint.constant = cellWidth - (cfg.kDefaultImageBubbleSize.width + cfg.avatarSize.width)
            
            cell.blackBackgroundVideoView.isHidden = true
            cell.bubbleImage.image = self.message.image!
            
            cell.bubbleImage.setBorderRadius(radius: 13)
            
            cell.bubbleImage.addGestureRecognizer(
                UITapGestureRecognizer(target: cell, action: #selector(cell.bubbleImageSelected(sender:)))
            )

        } else if message.messageType == .VideoMessage {
            leadingOrTrailingConstraint.constant = cellWidth - (cfg.kDefaultImageBubbleSize.width + cfg.avatarSize.width)
            
            cell.blackBackgroundVideoView.isHidden = false
            cell.bubbleImage.setBorderRadius(radius: 13)
            cell.blackBackgroundVideoView.setBorderRadius(radius: 13)
            
            if let url = message.video {
                DispatchQueue.global(qos: .userInitiated).async {
                    let thumbnailImage = Utils.thumbnailImageForVideo(withUrl: url, atTime: 1)
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        cell.bubbleImage.image = thumbnailImage
                        self.message.image = thumbnailImage
                    }
                }
            } else {  print("video nil") }
            
            cell.bubbleImage.addGestureRecognizer(
                UITapGestureRecognizer(target: cell, action: #selector(cell.bubbleImageSelected(sender:)))
            )
        } else if message.messageType == .VoiceMessage {
            
            if let url = message.voice {
                print("Video url is not nil")
                
                do {
                    if cell.player.index(forKey: indexPath.item) == nil {
                        cell.player[indexPath.item] = try AVAudioPlayer(contentsOf: url)
                        cell.player[indexPath.item]!.delegate = cell
                        cell.player[indexPath.item]!.prepareToPlay()
                        
                    }
                    cell.voiceMessagePlayButtonImage.addGestureRecognizer(UITapGestureRecognizer(target: cell, action: #selector(cell.playOrPauseVoiceButton(sender:))))
                    
                } catch let error {
                    print(error.localizedDescription)
                }
 
            }

            cell.voiceMessageView.setBorderRadius(radius: 17)
        }
    
        
        
        // Hide the Top label every 4 items.
        if indexPath.item % 4 != 0 {
            cell.cellTopLabelHeightContraint.constant = 0
        } else {
            cell.cellTopLabelHeightContraint.constant = cfg.kDefaultCellTopLabelHeight
        }
        // ---
        
        // If the avatar hidden option is true, let's hide the Avatar . Otherwise show it with default values
        if cfg.avatarIsHidden {
            cell.cellAvatarImageWidthConstraint.constant = 0
            
        } else {
            cell.cellAvatarImageWidthConstraint.constant = cfg.kDefaultCellAvatarImageWidth
            cell.avatarBubbleImage.setBorderRadius(radius: Int(cell.avatarBubbleImage.frame.width/2))
            
            // If the sender have an avatar image let's set it. Otherwise it'll be replaced with a custom background color
            if let img = message.senderAvatar {
                cell.avatarBubbleImage.image = img
            } else {
                cell.avatarBubbleImage.image = UIImage(withBackground: UIColor.lightGray)
            }
            // ---
            
        }
        // ---
        

        // Hide or show the bottom label of the cell.
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
    
    public func calculateCellSize(collectionView: UICollectionView) -> CGSize {
        
        let cfg = config
        
        let cellPaddingSpace = cfg.sectionInsets.left + cfg.sectionInsets.right
        let cellWidth = collectionView.frame.width - cellPaddingSpace
        let avatarSize = config.avatarSize
        var bubbleHeight: CGFloat = CGFloat(48.0)
        
        if message.messageType  == .TextMessage {
            let bubbleWidth = cellWidth - ((cfg.labelInsets.left + cfg.labelInsets.right) + (cfg.textInsets.left + cfg.textInsets.right) + avatarSize.width + cfg.kDefaultBubbleMargins)
            let baseHeight = CGFloat(48.0)
            
            bubbleHeight = ceil(message.text!.height(with: bubbleWidth, font: config.kDefaultTextFont)) + (cfg.labelInsets.top + cfg.labelInsets.bottom)
            
            bubbleHeight = bubbleHeight < baseHeight ? baseHeight : bubbleHeight
            
        } else if message.messageType == .ImageMessage || message.messageType == .VideoMessage {
            bubbleHeight = cfg.kDefaultImageBubbleSize.height + cfg.kDefaultCellTopLabelHeight + cfg.kDefaultCellBottomLabelHeight
        } else {
            bubbleHeight = 72.0
        }
        
        // for cell top label
        if indexPath.item % 4 != 0 {
            bubbleHeight -= cfg.kDefaultCellTopLabelHeight
        }
        
        // for cell bottom label
        if cfg.cellBottomLabelHidden && message.senderType == .Outgoing {
            bubbleHeight -= cfg.kDefaultCellBottomLabelHeight
        }
        
        let size = CGSize(width: cellWidth, height: bubbleHeight)
        print("Size: \(size)")
        return size
 
    }
    
    class CellBubbleConfig {
        
        public var cellBottomLabelHidden:Bool = false
        public var avatarIsHidden: Bool = false {
            willSet {
                self.avatarSize = newValue ? CGSize(width: 4, height: 0) : CGSize(width: 34, height: 30)
            }
        }
        
        // DEFAULT CONSTANTS -------
        
        // Avatar settings
        public var avatarBackgroundColor: UIColor? = UIColor.lightGray
        public var avatarSize: CGSize = CGSize(width: 34, height: 30)
        final public var kDefaultCellAvatarImageWidth: CGFloat = 30
        
        
        // Bubble color
        final public var kDefaultBubbleViewOutgoingColor: UIColor = UIColor(withRed: 0.0, green: 122.0, blue: 255.0)
        final public var kDefaultBubbleViewIncomingColor: UIColor = UIColor(withRed: 230.0, green: 229.0, blue: 234.0)
        
        // Text Color and Font
        final public var kDefaultTextIncomingColor: UIColor = UIColor.black
        final public var kDefaultTextOutgoingColor: UIColor = UIColor.white
        final public var kDefaultTextFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
        
        // Sizes
        final public var kDefaultCellBottomLabelHeight: CGFloat = 16
        final public var kDefaultCellTopLabelHeight:CGFloat = 16
        
        final public var kDefaultBubbleMargins: CGFloat = 20
        
        // Default size of images in Image Bubble
        final public var kDefaultImageBubbleSize: CGSize = CGSize(width: 190, height: 160)
        final public var kAddFactor:CGFloat = 1.367
        
        // ----------------------------
        
        
        // CUSTOM CONFIG VALUES ---
        public var sectionInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 0.0, right: 10.0)
        public var labelInsets = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 24.0, right: 0.0)
        public var textInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        init() {
            
        }
        
    }
    
    
    
}
