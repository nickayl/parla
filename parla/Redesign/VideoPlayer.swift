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
    private let playerVC: MobilePlayerViewController
    
    init(with videoMessage: PVideoMessage) {
        
        let videoUrl = videoMessage.videoUrl
        playerVC = MobilePlayerViewController(contentURL: videoUrl)
        playerVC.shouldAutoplay = false
        playerVC.title = "\(videoMessage.sender.name)'s video"
        playerVC.activityItems = [videoUrl]

    }
    
    public func play() {
        viewController?.presentMoviePlayerViewControllerAnimated(playerVC)
    }
    
    public func pause() {
       playerVC.pause()
    }
    
    public func stop() {
        playerVC.stop()
    }
    
    public func close() {
         playerVC.dismiss(animated: true, completion: nil)
    }
    
}
