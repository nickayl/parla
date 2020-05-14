//
//  VideoPlayer.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import AVKit

public protocol VideoPlayer {
    func play()
    func pause()
    func stop()
    func close()
}

public class AVPlayerVideoPlayer : VideoPlayer {
    
    private let viewController: UIViewController? = Parla.config.containerViewController
    private var playerVC: AVPlayerViewController?
    private var videoMessage: PVideoMessage
    
    init(with videoMessage: PVideoMessage) {
       self.videoMessage = videoMessage
    }
    
    public func play() {
        if let videoUrl = videoMessage.videoUrl {
            playerVC = AVPlayerViewController()
            playerVC!.player = AVPlayer(url: videoUrl)
           // playerVC!.shouldAutoplay = false
            playerVC!.title = "\(videoMessage.sender.name)'s video"
            //layerVC!.activityItems = [videoMessage.videoUrl]
            viewController?.present(playerVC!, animated: true, completion: nil)
        }
      //  viewController?.presentMoviePlayerViewControllerAnimated(playerVC)
    }
    
    public func pause() {
        playerVC?.player?.pause()
    }
    
    public func stop() {
        playerVC?.player?.replaceCurrentItem(with: nil)
    }
    
    public func close() {
        playerVC?.dismiss(animated: true, completion: nil)
    }
    
}

//@available(iOS, deprecated, message: "This VidePlayer implementation does no longer work.")
//public class MobilePlayerVideoPlayer : VideoPlayer {
//
//    private let viewController: UIViewController? = Parla.config.containerViewController
//    private var playerVC: MobilePlayerViewController?
//    private var videoMessage: PVideoMessage
//
//    init(with videoMessage: PVideoMessage) {
//       self.videoMessage = videoMessage
//    }
//
//    public func play() {
//        if playerVC == nil, let videoUrl = videoMessage.videoUrl {
//            playerVC = MobilePlayerViewController(contentURL: videoUrl)
//            playerVC!.shouldAutoplay = false
//            playerVC!.title = "\(videoMessage.sender.name)'s video"
//            playerVC!.activityItems = [videoMessage.videoUrl]
//            viewController?.present(playerVC!, animated: true, completion: nil)
//        }
//      //  viewController?.presentMoviePlayerViewControllerAnimated(playerVC)
//    }
//
//    public func pause() {
//       playerVC?.pause()
//    }
//
//    public func stop() {
//        playerVC?.stop()
//    }
//
//    public func close() {
//         playerVC?.dismiss(animated: true, completion: nil)
//    }
//
//}
