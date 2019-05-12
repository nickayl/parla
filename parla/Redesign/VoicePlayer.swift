//
//  VoicePlayer.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 12/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import AVKit

public protocol PAudioPlayerDelegate {
    func didStartPlayingAudio(with url: URL?, atSecondsFromStart: Int)
    func didStopPlayingAudio(with url: URL?, atSecondsFromStart: Int)
    func audioCurrentlyPlayingWith(currentTime time: Int, totalDuration duration: Int)
}

public protocol PAudioPlayer {
    var delegate: PAudioPlayerDelegate? { get set }
    
    func play()
    func pause()
    func stop()
    func toggle()
}

public class DefaultPAudioPlayer : NSObject, PAudioPlayer, AVAudioPlayerDelegate {
    
    private var voiceUrl: URL
    public var delegate: PAudioPlayerDelegate?
    
    private var player: AVAudioPlayer?
    private var timer: Timer = Timer()
    private var isTimerInPause = false
    
    public init(voiceUrl: URL, delegate: PAudioPlayerDelegate?) {
        self.voiceUrl = voiceUrl
        super.init()
        self.player = try? AVAudioPlayer(contentsOf: voiceUrl)
        self.player?.delegate = self
        self.delegate = delegate
    }
    
    public func play() {
        if let p = player, !p.isPlaying {
            self.delegate?.didStartPlayingAudio(with: voiceUrl, atSecondsFromStart: Int(player?.currentTime ?? 0))
            p.play()
            
            isTimerInPause = false
            
            if !timer.isValid {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerForMethod(_:)), userInfo: nil, repeats: true)
            }
        }
    }
    
    public func toggle() {
        if let p = player, !p.isPlaying {
            play()
        } else {
            pause()
        }
    }
    
    public func pause() {
        if let p = player, p.isPlaying {
            self.delegate?.didStopPlayingAudio(with: voiceUrl, atSecondsFromStart: Int(player?.currentTime ?? 0))
            p.pause()
            isTimerInPause = true
        }
    }
    
    public func stop() {
        self.delegate?.didStopPlayingAudio(with: voiceUrl, atSecondsFromStart: Int(player?.currentTime ?? 0))
        player?.stop()
        timer.invalidate()
    }
    
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
    
    @objc
    public func timerForMethod(_ timer: Timer) {
        if let p = player, !isTimerInPause {
            
            let curtime = Int(p.currentTime)
            let duration = Int(p.duration)
            
            self.delegate?.audioCurrentlyPlayingWith(currentTime: curtime, totalDuration: duration)
            
            print("Duration: \(p.duration) curtime: \(p.currentTime) ")//calc: \(voiceMessageProgressView.progress)")
            
            //  voiceMessageProgressView.setProgress(curtime/duration, animated: true)
        }
        
    }
    
    
}
