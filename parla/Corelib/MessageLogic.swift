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
let voiceMessageIncomingReuseIdentifier = "VoiceMessageCellIncomingXib"
let voiceMessageOutgoingReuseIdentifier = "VoiceMessageCellOutgoingXib"
// new ==>
let incomingFileMessageXibName = "IncomingFileMessageCell", incomingFileMessageReuseIdentifier = "FileIncomingXib"
let outgoingFileMessageXibName = "OutgoingFileMessageCell", outgoingFileMessageReuseIdentifier = "FileOutgoingXib"

@objc public protocol PMessageOptions {
    var isTopLabelActive: Bool { get set }
    var isBottomLabelActive: Bool { get set }
}

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
    var cellIdentifier: String { get }
    var isReadyToUse: Bool { get }
    var contentColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var isIncoming: Bool { get }
    var options: PMessageOptions { get }
    
    func displaySize(frameWidth: CGFloat) -> CGSize
    func triggerSelection(viewController: UIViewController?)
}

public protocol PTextMessage : PMessage {
    var text: String { get set }
    var enableCopyOnLongTouch: Bool { get set }
    init(id: Int, sender: PSender, text: String, date: Date)
}

public protocol PFileMessage : PMessage {
    var fileName: String { get set }
    var url: URL? { get set }
    var fileExt: String? { get set }
    init(id: Int, sender: PSender, fileName: String, url: URL, date: Date)
}

public protocol PVideoMessage : PMessage {
    var thumbnail: UIImage? { get set }
    var videoUrl: URL? { get set }
    var duration: Float? { get set }
    var player: VideoPlayer? { get set }
}

public protocol PVoiceMessage : PMessage {
    var duration: Float { get }
    var voiceUrl: URL { get set }
    var player: PAudioPlayer? { get set }
}

@objc public protocol PImageMessage : PMessage {
    var image: UIImage? { get set }
    var imageUrl: URL? { get set }
    var imageDescription: String?  { get set }
    var viewer: ImageViewer? { get set }
}

@objc public protocol PMapMessage : PImageMessage {
    var mapImageGenerator: MapImageGenerator? { get set }
    var coordinates: CLLocationCoordinate2D { get set }
    var address: String? { get set }
    var shouldDisplayLabel: Bool { get set }
    
    func startAsynch(completitionHandler: @escaping () -> Void)
}

class PMapMessageImpl : AbstractPMessage<CLLocationCoordinate2D>, PImageMessage, PMapMessage {
    
    public var image: UIImage?
    public var imageUrl: URL?
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
        self.options.isTopLabelActive = true
        self.isReadyToUse = false
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
            self.image = $0
            if !c { c = true }
            else {
                self.isReadyToUse = true
                self.delegate?.messageIsReadyToBeConsumed(message: self)
                completitionHandler()
            }
        }
    }
    
    public override func triggerSelection(viewController: UIViewController? = nil) {
        print("Open to external map app is the default behaviour of the triggerSelection function for a map message.")
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.address
        mapItem.openInMaps(launchOptions: nil)
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config
        return CGSize(width: frameWidth - (cfg.cell.sectionInsets.left + cfg.cell.sectionInsets.right), height: 160)
    }
    
    public override var cellIdentifier: String {
        return isIncoming ? incomingImageMessageReuseIdentifier : outgoingImageMessageReuseIdentifier
    }
    
}

class PVoiceMessageImpl : AbstractPMessage<URL>, PVoiceMessage, PAudioPlayerDelegate {
    
    public var duration: Float = 0
    public var voiceUrl: URL
    public var player: PAudioPlayer?
    
    public override var cellIdentifier: String {
        return sender.type == .Incoming ? "VoiceMessageCellIncomingXib" : "VoiceMessageCellOutgoingXib"
    }
    
    public init(id: Int, sender: PSender, date: Date = Date(), voiceUrl: URL) {
        self.voiceUrl = voiceUrl
        super.init(id: id, sender: sender, date: date, type: .VoiceMessage)
        self.player = DefaultPAudioPlayer(voiceUrl: voiceUrl, delegate: nil)
        self.content = voiceUrl
        self.backgroundColor = isIncoming ? Parla.config.cell.voiceIncomingColor : Parla.config.cell.voiceOutgoingColor
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config
        return CGSize(width: frameWidth - (cfg.cell.sectionInsets.left + cfg.cell.sectionInsets.right), height: 60)
    }
    
    public func didInitializeAVAudioPlayer(with: AVAudioPlayer) {
        self.duration = Float(with.duration)
    }
    
    public override func triggerSelection(viewController: UIViewController? = nil) {
        // TODO to be implemented
        print("Voice message by default does nothing when is selected")
    }
}

class PVideoMessageImpl : AbstractPMessage<URL>, PVideoMessage {
    
    public var thumbnail: UIImage?
    public var videoUrl: URL? {
        didSet {
            isReadyToUse = videoUrl != nil
        }
    }
    public var duration: Float?
    public var player: VideoPlayer?
    
    public override var cellIdentifier: String {
        return isIncoming ? incomingVideoMessageReuseIdentifier : outgoingVideoMessageReuseIdentifier
    }
    
    required public init(id: Int, sender: PSender, videoUrl: URL? = nil, thumbnail: UIImage? = nil, date: Date = Date()) {
        self.videoUrl = videoUrl
        self.thumbnail = thumbnail
        super.init(id: id, sender: sender, date: date, type: .VideoMessage)
        isReadyToUse = videoUrl != nil
        self.content = videoUrl
        
        self.player = AVPlayerVideoPlayer(with: self)
    }
    
    public override func triggerSelection(viewController: UIViewController? = nil) {
        player?.play()
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config
        return CGSize(width: frameWidth - (cfg.cell.sectionInsets.left + cfg.cell.sectionInsets.right), height: Parla.config.cell.kDefaultVideoBubbleSize.height)
    }
}

class PImageMessageImpl: AbstractPMessage<UIImage>, PImageMessage {
    
    public var image: UIImage?
    public var imageUrl: URL?
    public var imageDescription: String?
    public var viewer: ImageViewer?
    
    private let viewController = Parla.config.containerViewController!
    private let config = Parla.config
    
    public override var cellIdentifier: String {
        return isIncoming ? incomingImageMessageReuseIdentifier : outgoingImageMessageReuseIdentifier
    }
    
    public init(id: Int, sender: PSender, image: UIImage? = nil, imageUrl: URL? = nil, date: Date = Date()) {
        self.image = image
        self.imageUrl = imageUrl
        self.viewer = config.imageViewer
        super.init(id: id, sender: sender, date: date, type: .ImageMessage)
        self.content = image
    }
    
    public override func triggerSelection(viewController: UIViewController? = nil) {
        if let img = image, let vc = viewController {
            self.viewer?.show(image: img, in: vc)
        }
    }
    
    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        return CGSize(width: frameWidth - (config.cell.sectionInsets.left + config.cell.sectionInsets.right), height: Parla.config.cell.kDefaultImageBubbleSize.height)
    }
    
}

class PFileMessageImpl : PTextMessageImpl, PFileMessage, UIDocumentInteractionControllerDelegate {
    
    var fileExt: String?
    var fileName: String
    var url: URL?
    var viewController: UIViewController?
    
     // Initialize Document Interaction Controller
    var documentInteractionController = UIDocumentInteractionController()
    
    public override var enableCopyOnLongTouch: Bool {
        didSet {
            label?.canCopyText = false
        }
    }
    
    override var cellIdentifier: String {
        return isIncoming ? incomingFileMessageReuseIdentifier : outgoingFileMessageReuseIdentifier
    }
    
    required init(id: Int, sender: PSender, fileName: String, url: URL, date: Date = Date()) {
        self.fileName = fileName
        self.url = url
        // Configure Document Interaction Controller
        super.init(id: id, sender: sender, text: fileName, date: date)
        documentInteractionController.delegate = self
    }

    required public init(id: Int, sender: PSender, text: String, date: Date = Date()) {
        self.fileName = text
        // Configure Document Interaction Controller
        super.init(id: id, sender: sender, text: text, date: date)
        documentInteractionController.delegate = self
    }
    
    private func documentInteractionControllerViewControllerForPreview
        (controller: UIDocumentInteractionController) -> UIViewController {
        return viewController!
    }
    
    override func triggerSelection(viewController: UIViewController? = nil) {
        print("Trigger selection on File message")
        self.viewController = viewController
        
        if let vc = viewController, let u = url {
             documentInteractionController.url = u
            
             // Present Open In Menu
            documentInteractionController.presentOptionsMenu(from: vc.view.frame, in: vc.view, animated: true)
        }
    }
}

class PTextMessageImpl : AbstractPMessage<String>, PTextMessage {
    
    public var text: String
    public var label: CopyableText?
    
    public var enableCopyOnLongTouch: Bool = true {
        didSet {
                label?.canCopyText = self.enableCopyOnLongTouch
        }
    }
    
    public override var cellIdentifier: String {
        return isIncoming ? incomingTextMessageReuseIdentifier : outgoingTextMessageReuseIdentifier
    }
    
    required public init(id: Int, sender: PSender, text: String, date: Date = Date()) {
        self.text = text
        super.init(id: id, sender: sender, date: date, type: .TextMessage)
        self.content = text
        self.label?.canCopyText = enableCopyOnLongTouch
    }

    public override func displaySize(frameWidth: CGFloat) -> CGSize {
        let cfg = Parla.config
        var cellWidth = frameWidth
        let avatarSize = self.sender.avatar.size
        
        let cellPaddingSpace = cfg.cell.sectionInsets.left + cfg.cell.sectionInsets.right
        cellWidth -= cellPaddingSpace
        
        let bubbleWidth = cellWidth - ((cfg.cell.labelInsets.left + cfg.cell.labelInsets.right) + (cfg.cell.textInsets.left + cfg.cell.textInsets.right) + (avatarSize.width*2) + cfg.cell.kDefaultBubbleMargins)
        
        let baseHeight = CGFloat(36.0)
        var cellHeight = baseHeight

        cellHeight = ceil(text.height(with: bubbleWidth, font: cfg.cell.kDefaultTextFont)) + (cfg.cell.labelInsets.top + cfg.cell.labelInsets.bottom)
        cellHeight = cellHeight < baseHeight ? baseHeight : cellHeight
     
        
        let bottomLabelHeight = CGFloat(options.isBottomLabelActive ? CGFloat(cfg.cell.bottomLabelHeight) : 0)
        let topLabelHeight = options.isTopLabelActive ? CGFloat(cfg.cell.topLabelHeight) : 0
        
        cellHeight += bottomLabelHeight
        cellHeight += topLabelHeight
        
        if cellHeight < (avatarSize.height + bottomLabelHeight + topLabelHeight) {
            cellHeight += (avatarSize.height + bottomLabelHeight + topLabelHeight) - cellHeight
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    public override func triggerSelection(viewController: UIViewController? = nil) {
        print("TextMessage does nothing when is tapped")
    }
    
}

public class AbstractPMessage<T> : NSObject, PMessage, Comparable {
    
  //  public var isTopLabelActive: Bool = false
    public var messageId: Int = 0
    public var date: Date
    public var sender: PSender
    public var messageType: MessageType
    public var content: T?
    public var isReadyToUse: Bool = true
    public var delegate: PMessageDelegate?
    public var options: PMessageOptions
    
    public var contentColor: UIColor = Parla.CellConfig.kDefaultContentColor
    public var backgroundColor: UIColor = Parla.CellConfig.kDefaultBackgroundColor
    
    public var isIncoming: Bool {
        return sender.type == .Incoming
    }
    
    public var toString: String {
        return "[messageType: \(messageType.rawValue) sender: \(sender.name) content: \(content)]"
    }

    public var cellIdentifier: String {
        assertionFailure("cellIdentifier has not been overridden -- All the class that belongs to this inheritance hierarchy must override this method and provide a valid cell identifier for the UICollectionView. This is a fatal error and therefore the application must be terminated")
        return ""
    }
    
    public func displaySize(frameWidth: CGFloat) -> CGSize {
       assertionFailure("displaySize has not been overridden -- All the class that belongs to this inheritance hierarchy must override this method and provide a valid size for display this kind of message properly to be ussed by the underlying UICollectionView. This is a fatal error and therefore the application must be terminated")
        return CGSize(width: 0, height: 0)
    }
    
    public func triggerSelection(viewController: UIViewController? = nil) {
        // optional method to be overridden by subclasses that intend to provide a behaviour when the message is selected (by default, when the cell is touched, but you can change the kind of gesture that will trigger a selection event. For example, a long touch could be attached to the trigger selection event to perform some operation.)
        print("This message does nothing on selection")
    }
    
    fileprivate init(id: Int, sender: PSender, date: Date = Date(), type: MessageType) {
        self.messageId = id
        self.date = date
        self.sender = sender
        self.messageType = type
        self.options = PMessageOptionsImpl()
        super.init()
        if isIncoming {
            self.contentColor = Parla.config.cell.textIncomingColor
            self.backgroundColor = Parla.config.cell.textMessageBubbleIncomingColor
        } else {
            self.contentColor = Parla.config.cell.textOutgoingColor
            self.backgroundColor = Parla.config.cell.textMessageBubbleOutgoingColor
        }
    }
    
    public static func == (lhs: AbstractPMessage, rhs: AbstractPMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    public static func < (lhs: AbstractPMessage, rhs: AbstractPMessage) -> Bool {
        return lhs.date.compare(rhs.date).rawValue < 0
    }
    
}

@objc public class PMessageOptionsImpl : NSObject, PMessageOptions {
    public var isTopLabelActive: Bool = false
    public var isBottomLabelActive: Bool = true
}

