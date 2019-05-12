//
//  VideoPlayer.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import MobilePlayer

public protocol VideoPlayer {
    func play()
    func pause()
    func stop()
    func close()
}

public class MobilePlayerVideoPlayer : VideoPlayer {
    
    private let viewController: UIViewController? = Parla.config?.containerViewController
    private var playerVC: MobilePlayerViewController?
    private var videoMessage: PVideoMessage
    
    init(with videoMessage: PVideoMessage) {
       self.videoMessage = videoMessage
    }
    
    public func play() {
        if playerVC == nil {
            playerVC = MobilePlayerViewController(contentURL: videoMessage.videoUrl)
            playerVC!.shouldAutoplay = false
            playerVC!.title = "\(videoMessage.sender.name)'s video"
            playerVC!.activityItems = [videoMessage.videoUrl]
        }
        viewController?.presentMoviePlayerViewControllerAnimated(playerVC)
    }
    
    public func pause() {
       playerVC?.pause()
    }
    
    public func stop() {
        playerVC?.stop()
    }
    
    public func close() {
         playerVC?.dismiss(animated: true, completion: nil)
    }
    
}
