//
//  VoiceRecorder.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 12/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import AVKit

public protocol VoiceRecorder {
  //  var audioFilename: String { get set }
    var audioUrl: URL { get set }
    var delegate: VoiceRecorderDelegate? { get set }
    var isRecording: Bool { get }
    
    func startAsynch(onRecordBegin: @escaping () -> Void) throws
    func stop() -> URL?
    func toggle() throws
    init(withFilename: String?)
}

public protocol VoiceRecorderDelegate {
    func voiceRecorderDidStartRecording(at url: URL, voiceRecorder: VoiceRecorder)
    func voiceRecorderDidEndRecording(at url: URL, voiceRecorder: VoiceRecorder)
}

public enum VoiceRecorderError : Error {
    case recordingError
}

public class DefaultVoiceRecorder : NSObject, VoiceRecorder, AVAudioRecorderDelegate {
    
    
    public var delegate: VoiceRecorderDelegate?
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    public var audioUrl: URL
    public var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
//    public var audioFilename: String {
//        didSet {
//            self.audioUrl = URL.documentsDirectory.appendingPathComponent(audioFilename)
//        }
//    }
    
    public required init(withFilename name: String? = nil) {
      //  self.audioFilename = name ?? "voice_\(Date().toString()!)"
        self.audioUrl = URL.documentsDirectory.appendingPathComponent("voice_default.m4a")
        super.init()
        
        recordingSession = AVAudioSession.sharedInstance()
     //   try? recordingSession?.setCategory(AVAudioSession.Category.playAndRecord)
    }
    

    public func startAsynch(onRecordBegin: @escaping () -> Void) throws {
        try? recordingSession?.setCategory(AVAudioSession.Category.playAndRecord)
        try recordingSession?.setActive(true)
        
        recordingSession?.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if !allowed { return }
                print("Allowed to register audio")
                
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue ]
                
                self.audioRecorder = try? AVAudioRecorder(url: self.audioUrl, settings: settings)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.prepareToRecord()
                self.audioRecorder?.record()
                
                if self.audioRecorder != nil {
                    onRecordBegin()
                    self.delegate?.voiceRecorderDidStartRecording(at: self.audioUrl, voiceRecorder: self)
                }
            }
        }
    }
    
 
    public func stop() -> URL? {
        audioRecorder?.stop()
      //  try? recordingSession?.setActive(false)
        print("Stopped voice recording and save file as \(self.audioUrl.absoluteString)")
        self.delegate?.voiceRecorderDidEndRecording(at: self.audioUrl, voiceRecorder: self)
        return self.audioUrl
    }
    
    public func toggle() throws {
        if let a = audioRecorder, a.isRecording {
            stop()
        } else {
            try startAsynch(onRecordBegin: { })
        }
    }
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finish recording "+flag.description)
    }
    
}
