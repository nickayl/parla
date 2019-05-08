//
//  BubbleViewCell.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 16/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import UIKit
//import SKPhotoBrowser
import AVFoundation

class BubbleViewCell: UICollectionViewCell, AVAudioPlayerDelegate {
    
    @IBOutlet var textLabel: UIPaddingLabel!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UIPaddingLabel!
    @IBOutlet var avatarBubbleImage: UIImageView!
    
    @IBOutlet var cellTopLabelHeightContraint: NSLayoutConstraint!
    @IBOutlet var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cellAvatarImageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var bubbleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var bubbleLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var bubbleImage: UIImageView!
    @IBOutlet var blackBackgroundVideoView: UIView!
    
    // Voice message outlets
    @IBOutlet var voiceMessageView: UIView!
    @IBOutlet var voiceMessageProgressView: UIProgressView!
    @IBOutlet var voiceMessagePlayButtonImage: UIImageView!
    
    
    var viewController: ChatViewController!
    var indexPath: IndexPath!
    public var player: [Int : AVAudioPlayer] = [:]
    public var timer: Timer = Timer()
    private var isTimerInPause = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse")
        
        isTimerInPause = false
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Awake from nib")
    }
    
    
    @objc func bubbleImageSelected(sender: UITapGestureRecognizer) {
        viewController.didTapMessageBubble(at: indexPath, collectionView: viewController.collectionView)
    }
    
    @objc func playOrPauseVoiceButton(sender: UITapGestureRecognizer) {
  //      let m = viewController.messageForBubbble(at: indexPath, collectionView: viewController.collectionView)
        
        let index = indexPath.item
        if !timer.isValid {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerForMethod(_:)), userInfo: nil, repeats: true)
        }
        
        if player[index]!.isPlaying {
            print("Currently playing voice")
            player[index]!.pause()
            voiceMessagePlayButtonImage.image = UIImage(named: "play100")
            isTimerInPause = true
            return ;
        } else if player[index]!.currentTime >= 0 { // this means it is currently in pause mode.
            player[index]!.play()
            voiceMessagePlayButtonImage.image = UIImage(named: "pause100")
            print("playing sound : duration \(player[index]!.duration) ")
            isTimerInPause = false
        }
    
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finishing playing media \(flag.description)")
        voiceMessagePlayButtonImage.image = UIImage(named: "play100")
        player.stop()
        timer.invalidate()
    }
    @objc  
    public func timerForMethod(_ timer: Timer) {
        if !isTimerInPause {
            let p = player[indexPath.item]!
            
            let curtime = Float(p.currentTime)
            let duration = Float(p.duration)
            
            print("Duration: \(p.duration) curtime: \(p.currentTime) calc: \(voiceMessageProgressView.progress)")
            
            voiceMessageProgressView.setProgress(curtime/duration, animated: true)
        }
        
    }

    
}
