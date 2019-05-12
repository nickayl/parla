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
    var audioFilename: String { get set }
    var audioUrl: URL { get }
    
    func startAsynch(onRecordBegin: @escaping () -> Void) throws
    func stop() -> URL?
    func toggle(onStart: (() -> Void)?) throws -> URL?
    init(withFilename: String?)
}

public enum VoiceRecorderError : Error {
    case recordingError
}

public class DefaultVoiceRecorder : NSObject, VoiceRecorder, AVAudioRecorderDelegate {
    
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    public var audioUrl: URL
    public var audioFilename: String {
        didSet {
            self.audioUrl = URL.documentsDirectory.appendingPathComponent(audioFilename)
        }
    }
    
    public required init(withFilename name: String? = nil) {
        self.audioFilename = name ?? "voice_\(Date().toString()!)"
        self.audioUrl = URL.documentsDirectory.appendingPathComponent(audioFilename)
    }
    

    public func startAsynch(onRecordBegin: @escaping () -> Void) throws {
        
        do {
            recordingSession = AVAudioSession.sharedInstance()
            try recordingSession?.setCategory(AVAudioSession.Category.playAndRecord)
            try recordingSession?.setActive(true)
        } catch {
            throw VoiceRecorderError.recordingError
        }
        
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
                
                if let r = self.audioRecorder, !r.isRecording {
                    r.record()
                    onRecordBegin()
                }
                
            }
        }
    }
    
 
    public func stop() -> URL? {
        audioRecorder?.stop()
        print("Stopped voice recording and save file as \(self.audioFilename)")
        return audioUrl
    }
    
    public func toggle(onStart: (() -> Void)?) throws -> URL? {
        if audioRecorder != nil {
           return stop()
        } else {
            try startAsynch(onRecordBegin: {
                onStart?()
            })
        }
        return nil
    }
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finish recording "+flag.description)
    }
    
}
