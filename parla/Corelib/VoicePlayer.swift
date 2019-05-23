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
    func didStartPlayingAudio(with url: URL?, atSecondsFromStart: Int, wasInPause: Bool)
    func didStopPlayingAudio(with url: URL?, atSecondsFromStart: Int, pause: Bool)
    func audioCurrentlyPlayingWith(currentTime time: Float, totalDuration duration: Float)
}

public protocol PAudioPlayerOptionalDelegate {
    func didInitializeAVAudioPlayer(with: AVAudioPlayer)
}

public protocol PAudioPlayer {
    var delegate: PAudioPlayerDelegate? { get set }
    var optionalDelegate: PAudioPlayerOptionalDelegate? { get set }
    var currentProgress: Float { get }
    
    func play()
    func pause()
    func stop()
    func toggle()
}

public class DefaultPAudioPlayer : NSObject, PAudioPlayer, AVAudioPlayerDelegate {
    
    private var voiceUrl: URL
    
    public var currentProgress: Float = 0
    
    public var delegate: PAudioPlayerDelegate?
    public var optionalDelegate: PAudioPlayerOptionalDelegate?
    
    private var player: AVAudioPlayer?
    private var timer: Timer = Timer()
  //  private var isTimerInPause = false
    private var playSession: AVAudioSession?
    
    public init(voiceUrl: URL, delegate: PAudioPlayerDelegate?) {
        self.voiceUrl = voiceUrl
        self.delegate = delegate
    }
    
    public func play() {
        
        player?.play()
        self.delegate?.didStartPlayingAudio(with: voiceUrl, atSecondsFromStart: Int(player?.currentTime ?? 0), wasInPause: (player?.currentTime ?? 0.5) >= 0.5)
            
        if !timer.isValid {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerForMethod(_:)), userInfo: nil, repeats: true)
        }
        
      //   self.currentTime = 0
        
    }
    
    public func toggle() {
        if self.playSession == nil || self.player == nil {
            initializePlayer()
        }
        
        if let p = player {
            
            if !p.isPlaying {
                play()
            } else {
                pause()
            }
        }
        
    }
    
    public func pause() {
        if let p = player, p.isPlaying {
            p.pause()
            self.delegate?.didStopPlayingAudio(with: voiceUrl, atSecondsFromStart: Int(player?.currentTime ?? 0), pause: true)
          //  isTimerInPause = true
            timer.invalidate()
        }
    }
    
    public func stop() {
        self.currentProgress = 1
        player?.stop()
        self.delegate?.didStopPlayingAudio(with: voiceUrl, atSecondsFromStart: Int(player?.currentTime ?? 0), pause: false)
        timer.invalidate()
    }
    
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
    
    @objc
    public func timerForMethod(_ timer: Timer) {
        if let p = player, timer.isValid {
            self.currentProgress = Float(p.currentTime / p.duration)
            self.delegate?.audioCurrentlyPlayingWith(currentTime: Float(p.currentTime), totalDuration: Float(p.duration))
            
            print("Duration: \(p.duration) curtime: \(p.currentTime) ")//calc: \(voiceMessageProgressView.progress)")
            
            //  voiceMessageProgressView.setProgress(curtime/duration, animated: true)
        }
        
    }
    
    private func initializePlayer() {
        self.playSession = AVAudioSession.sharedInstance()
        do {
            try self.playSession?.setCategory(.playback)
            try playSession?.setActive(true)
            self.player = try AVAudioPlayer(contentsOf: voiceUrl)
            self.player?.delegate = self
            
            if let p = player {
                optionalDelegate?.didInitializeAVAudioPlayer(with: p)
            }
            
        } catch  {
            print("==>> Error instantiating AVAudioPlayer \(error) <<===")
        }
    }
    
    
}
