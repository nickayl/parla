//
//  SMessage.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 17/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import CoreLocation
import MapKit

let incomingTextMessageXibName = "IncomingTextMessageCell", incomingTextMessageReuseIdentifier = "TextIncomingXib"
let outgoingTextMessageXibName = "OutgoingTextMessageCell", outgoingTextMessageReuseIdentifier = "TextOutgoingXib"
let incomingImageMessageXibName = "IncomingImageMessageCell", incomingImageMessageReuseIdentifier = "ImageIncomingXib"
let outgoingImageMessageXibName = "OutgoingImageMessageCell", outgoingImageMessageReuseIdentifier = "ImageOutgoingXib"
let incomingVoiceMessageXibName = "VoiceMessageCell", incomingVoiceMessageReuseIdenfitier = "VoiceIncomingXib"
let outgoingVideoMessageXibName = "OutgoingVideoMessageCell", outgoingVideoMessageReuseIdentifier = "VideoOutgoingXib"
let incomingVideoMessageXibName = "IncomingVideoMessageCell", incomingVideoMessageReuseIdentifier = "VideoIncomingXib"
let voiceMessageReuseIdentifier = "VoiceMessageCellXib"

@objc public enum MessageType : Int {
    case ImageMessage, VideoMessage, TextMessage, VoiceMessage, MapMessage
}

@objc public protocol ToStringRepresentable {
    var toString: String { get }
}

@objc public protocol PMessageDelegate {
    func messageIsReadyToBeConsumed(message: PMessage)
}

@objc public protocol PMessage : ToStringRepresentable {
    var messageId: Int { get set }
    var delegate: PMessageDelegate? { get set }
    var date: Date { get set }
    var sender: PSender { get set }
    var messageType: MessageType { get }
    var senderType: SenderType { get }
    var cellIdentifier: String { get }
    var isTopLabelActive: Bool { get set }
    var isReadyToUse: Bool { get }
    
    func displaySize(frameWidth: CGFloat) -> CGSize
    func triggerSelection()
}

public protocol PTextMessage : PMessage {
    var text: String { get set }
    var enableCopyOnLongTouch: Bool { get set }
    init(id: Int, sender: PSender, text: String, date: Date)
}

public protocol PVideoMessage : PMessage {
    var thumbnail: UIImage? { get set }
    var videoUrl: URL { get set }
    var duration: Float? { get set }
    var player: VideoPlayer? { get set }
    init(id: Int, sender: PSender, videoUrl: URL, thumbnail: UIImage?, date: Date)
}

public protocol PVoiceMessage : PMessage {
    var duration: Float { get }
    var voiceUrl: URL { get set }
    var player: PAudioPlayer? { get set }
}

@objc public protocol PImageMessage : PMessage {
    var image: UIImage! { get set }
    var imageDescription: String?  { get set }
  //  var viewController: UIViewController! { get set }
    var viewer: ImageViewer? { get set }
//    init(id: Int, sender: PSender, image: UIImage, date: Date)
}

@objc public protocol PMapMessage : PImageMessage {
    var mapImageGenerator: MapImageGenerator? { get set }
    var coordinates: CLLocationCoordinate2D { get set }
    var address: String? { get set }
    var shouldDisplayLabel: Bool { get set }
    
  //  func openToExternalMapApp()
    func startAsynch(completitionHandler: @escaping () -> Void)
}

public class PMapMessageImpl : AbstractPMessage<CLLocationCoordinate2D>, PImageMessage, PMapMessage {
    
    public var image: UIImage!
    public var imageDescription: String?
    public var viewer: ImageViewer?
    public var mapImageGenerator: MapImageGenerator?
    public var coordinates: CLLocationCoordinate2D
    public var shouldDisplayLabel: Bool = true
    public var address: String? {
        didSet {
            self.imageDescription = address
        }
    }
    private lazy var geocoder = CLGeocoder()
    
    public init(id: Int, sender: PSender, date: Date = Date(), coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
        self.mapImageGenerator = MapKitImageGenerator()
        super.init(id: id, sender: sender, type: .MapMessage)
        self.content = coordinates
        self.isTopLabelActive = true
        self.isReadyToUse = false
    }
    
    public override func triggerSelection() {
        print("Open to external map app")
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.address
        mapItem.openInMaps(launchOptions: nil)
    }
    
    public func startAsynch(completitionHandler: @escaping () -> Void) {
        let location = CLLocation(latitude: CLLocationDegrees(coordinates.latitude), longitude: CLLocationDegrees(coordinates.longitude))
        var c = false
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let l = placemarks?.first {
                print("Finished reverse geolocation")
                self.address = "\(l.thoroughfare ?? "") \(l.subThoroughfare ?? "") \(l.postalCode ?? ""), \(l.locality ?? "") - \(l.country ?? "")"
                if !c { c = true }
                else {
                    self.isReadyToUse = true
                    self.delegate?.messageIsReadyToBeConsumed(message: self)
                    completitionHandler()
                }
            }
            
        }
        
        self.mapImageGenerator?.generateImageFor(coordinates: coordinates, withPlacemark: true) {
            print("Finished loading image...")
            self.image = $0!
            if !c { c = true }
            else {
                self.isReadyToUse = true
                self.delegate?.messageIsReadyToBeConsumed(message: self)
                completitionHandler()
            }
        }
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config!
        return CGSize(width: frameWidth - (cfg.sectionInsets.left + cfg.sectionInsets.right), height: 160)
    }
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingImageMessageReuseIdentifier : outgoingImageMessageReuseIdentifier
    }
    
}

public class PVoiceMessageImpl : AbstractPMessage<URL>, PVoiceMessage, PAudioPlayerOptionalDelegate {
    
    public var duration: Float = 0
    public var voiceUrl: URL
    public var player: PAudioPlayer?
    
    public override var cellIdentifier: String {
        return voiceMessageReuseIdentifier
    }
    
    public init(id: Int, sender: PSender, date: Date = Date(), voiceUrl: URL) {
        self.voiceUrl = voiceUrl
        super.init(id: id, sender: sender, date: date, type: .VoiceMessage)
        self.player = DefaultPAudioPlayer(voiceUrl: voiceUrl, delegate: nil)
        self.player?.optionalDelegate = self
        self.content = voiceUrl
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config!
        return CGSize(width: frameWidth - (cfg.sectionInsets.left + cfg.sectionInsets.right), height: 72)
    }
    
    public func didInitializeAVAudioPlayer(with: AVAudioPlayer) {
        self.duration = Float(with.duration)
    }
}

public class PVideoMessageImpl : AbstractPMessage<URL>, PVideoMessage {
    
    public var thumbnail: UIImage?
    public var videoUrl: URL
    public var duration: Float?
    public var player: VideoPlayer?
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingVideoMessageReuseIdentifier : outgoingVideoMessageReuseIdentifier
    }
    
    required public init(id: Int, sender: PSender, videoUrl: URL, thumbnail: UIImage? = nil, date: Date = Date()) {
        self.videoUrl = videoUrl
        self.thumbnail = thumbnail
        super.init(id: id, sender: sender, date: date, type: .VideoMessage)
        self.content = videoUrl
        
        self.player = MobilePlayerVideoPlayer(with: self)
    }
    
    public override func triggerSelection() {
        player?.play()
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config!
        return CGSize(width: frameWidth - (cfg.sectionInsets.left + cfg.sectionInsets.right), height: 160)
    }
}

public class PImageMessageImpl: AbstractPMessage<UIImage>, PImageMessage {
    
    public var image: UIImage!
    public var imageDescription: String?
    public var viewer: ImageViewer?
    
    private let viewController = Parla.config!.containerViewController!
    private let config = Parla.config!
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingImageMessageReuseIdentifier : outgoingImageMessageReuseIdentifier
    }
    
    public init(id: Int, sender: PSender, image: UIImage, date: Date = Date()) {
        self.image = image
        self.viewer = config.kDefaultImageMessageViewer
        super.init(id: id, sender: sender, date: date, type: .ImageMessage)
        self.content = image
    }
    
    public override func triggerSelection() {
        self.viewer?.show(image: image)
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        return CGSize(width: frameWidth - (config.sectionInsets.left + config.sectionInsets.right), height: 160)
    }
    
}

public class PTextMessageImpl : AbstractPMessage<String>, PTextMessage {
    
    public var text: String
    public var label: CopyableText?
    
    public var enableCopyOnLongTouch: Bool = true {
        didSet {
                label?.canCopyText = self.enableCopyOnLongTouch
//            } else {
//                print("WARNING ==> CANNOT COPY TEXT WITHOUT AN ASSIGNED UIPaddingLabel. Please use the correct initializer. <== ")
//            }
        }
    }
    
    public override var cellIdentifier: String {
        return senderType == .Incoming ? incomingTextMessageReuseIdentifier : outgoingTextMessageReuseIdentifier
    }
    
    required public init(id: Int, sender: PSender, text: String, date: Date = Date()) {
        self.text = text
        super.init(id: id, sender: sender, date: date, type: .TextMessage)
        self.content = text
        self.label?.canCopyText = enableCopyOnLongTouch
    }

    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config!
        var cellWidth = frameWidth
        let avatarSize = self.sender.avatar != nil ? cfg.avatarSize : CGSize(width: 0, height: 0)
        
        let cellPaddingSpace = cfg.sectionInsets.left + cfg.sectionInsets.right
        cellWidth -= cellPaddingSpace
        
        let bubbleWidth = cellWidth - ((cfg.labelInsets.left + cfg.labelInsets.right) + (cfg.textInsets.left + cfg.textInsets.right) + avatarSize.width + cfg.kDefaultBubbleMargins)
        
        let baseHeight = CGFloat(52.0)
        var bubbleHeight = baseHeight
        
        if(self.text.count > 60 || self.text.contains("\n")) {
            bubbleHeight = ceil(text.height(with: bubbleWidth, font: cfg.kDefaultTextFont)) + (cfg.labelInsets.top + cfg.labelInsets.bottom)
            bubbleHeight = bubbleHeight < baseHeight ? baseHeight : bubbleHeight
        }
        
        bubbleHeight += isTopLabelActive ? 19 : 0
        
        return CGSize(width: cellWidth, height: bubbleHeight)
    }
    
    
    public override func triggerSelection() {
        print("TextMessage does nothing when is tapped")
    }
    
}

public class AbstractPMessage<T> : NSObject, PMessage, Comparable {
    
    public var isTopLabelActive: Bool = false
    public var messageId: Int = 0
    public var date: Date
    public var sender: PSender
    public var messageType: MessageType
    public var content: T?
    public var isReadyToUse: Bool = true
    public var delegate: PMessageDelegate?
    
    public var toString: String {
        return "[messageType: \(messageType.rawValue) sender: \(sender.name) content: \(content)]"
    }
    
    public var senderType: SenderType {
        return sender == Parla.config.sender ? .Outgoing : .Incoming
    }

    public var cellIdentifier: String {
        return ""
    }
    
    public func displaySize(frameWidth: CGFloat) -> CGSize {
        return CGSize(width: 50, height: 38)
    }
    
    public func triggerSelection() {
        print("This message does nothing on selection")
    }
    
    fileprivate init(id: Int, sender: PSender, date: Date = Date(), type: MessageType) {
        self.messageId = id
        self.date = date
        self.sender = sender
        self.messageType = type
    }
    
    public static func == (lhs: AbstractPMessage, rhs: AbstractPMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    public static func < (lhs: AbstractPMessage, rhs: AbstractPMessage) -> Bool {
        return lhs.date.compare(rhs.date).rawValue < 0
    }
    
}


