//
//  ParlaConfig.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SDWebImage

public final class Parla {
    
    public static func newTextMessage(id: Int, sender: PSender, text: String, date: Date = Date()) -> PTextMessage {
        return PTextMessageImpl(id: id, sender: sender, text: text, date: date)
    }
    
    public static func newImageMessage(id: Int, sender: PSender, image: UIImage, date: Date = Date()) -> PImageMessage {
        return PImageMessageImpl(id: id, sender: sender, image: image, date: date)
    }
    
    public static func newImageMessage(id: Int, sender: PSender, imageUrl: URL, date: Date = Date()) -> PImageMessage {
        return PImageMessageImpl(id: id, sender: sender, imageUrl: imageUrl , date: date)
    }
    
    public static func newVideoMessage(id: Int, sender: PSender, videoUrl: URL? = nil, thumbnail: UIImage? = nil, date: Date = Date()) -> PVideoMessage {
        return PVideoMessageImpl(id: id, sender: sender, videoUrl: videoUrl, thumbnail: thumbnail, date: date)
    }
    
    public static func newVoiceMessage(id: Int, sender: PSender, date: Date = Date(), voiceUrl: URL) -> PVoiceMessage {
        return PVoiceMessageImpl(id: id, sender: sender, date: date, voiceUrl: voiceUrl)
    }
    
    public static func newMapMessage(id: Int, sender: PSender, date: Date = Date(), coordinates: CLLocationCoordinate2D) -> PMapMessage {
        return PMapMessageImpl(id: id, sender: sender, date: date, coordinates: coordinates)
    }
    
    // ==== Preloading ==== //
    static var hasBeenPreloaded: Bool = false
    static var parlaInputToolbar: ParlaInputToolbar!
    static var parlaCollectionView: UICollectionView!
    static var microphoneView: UIMicrophoneView!
    
    static let cocoapodsBundle: Bundle? = Bundle(identifier: "org.cocoapods.ParlaKit")
    static let debugBundle = Bundle.main
    static let bundle = cocoapodsBundle!
    
    public static let SDWebImageSharedConfig = SDWebImageDownloader.shared
    
    public static func preload(withFrame frame: CGRect) {
        let startDate = Date()
        print("Preloading started")
        parlaCollectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        parlaCollectionView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "ParlaInputToolbar", bundle: bundle)
        let mainView = nib.instantiate(withOwner: nil, options: nil).first as? UIView
        
        parlaInputToolbar = mainView?.subviews[0] as? ParlaInputToolbar
        microphoneView = mainView?.subviews[1] as? UIMicrophoneView
        
        let b = bundle
        
        parlaCollectionView.register(UINib(nibName: incomingTextMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingTextMessageReuseIdentifier)
        parlaCollectionView.register(UINib(nibName: outgoingTextMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingTextMessageReuseIdentifier)
        parlaCollectionView.register(UINib(nibName: incomingImageMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingImageMessageReuseIdentifier)
        parlaCollectionView.register(UINib(nibName: outgoingImageMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingImageMessageReuseIdentifier)
        parlaCollectionView.register(UINib(nibName: incomingVideoMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingVideoMessageReuseIdentifier)
        parlaCollectionView.register(UINib(nibName: outgoingVideoMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingVideoMessageReuseIdentifier)
        parlaCollectionView.register(UINib(nibName: incomingVoiceMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingVoiceMessageReuseIdenfitier)
        parlaCollectionView.register(UINib(nibName: "VoiceMessageCellIncoming", bundle: b), forCellWithReuseIdentifier: voiceMessageIncomingReuseIdentifier)
        parlaCollectionView.register(UINib(nibName: "VoiceMessageCellOutgoing", bundle: b), forCellWithReuseIdentifier: voiceMessageOutgoingReuseIdentifier)
        
        parlaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        hasBeenPreloaded = true
        print("Preloading finished with duration: \(Date().timeIntervalSince(startDate))")
    }
    
    public static func preloadAsynch(withFrame frame: CGRect) {
        DispatchQueue.main.async {
            print("Preloading asynch ...")
            Parla.preload(withFrame: frame)
        }
    }
    
    // ======= //
    
    public static func outgoingSender(id: Int, name: String, avatar: PAvatar?) -> POutgoingSender {
        if let instance = outgoingSenderInstance {
            return instance
        }
        
        outgoingSenderInstance = POutgoingSender(id: id, name: name, avatar: avatar)
        return outgoingSenderInstance!
    }
    
    private static var outgoingSenderInstance: POutgoingSender?
    
    public var containerViewController: UIViewController! {
        didSet {
            self.kDefaultImageMessageViewer = SKPhotoBrowserImageViewer.getInstance()
            self.kDefaultMediaPicker = SystemMediaPicker(viewController: self.containerViewController)
            self.kDefaultAccessoryActionChooser = ActionSheetAccessoryActionChooser(viewController: self.containerViewController)
            self.mediaPicker = self.kDefaultMediaPicker
            self.imageViewer = self.kDefaultImageMessageViewer
            self.accessoryActionChooser = kDefaultAccessoryActionChooser
        }
    }
    
    public var sender: PSender!
    public var mediaPicker: MediaPicker?
    public var accessoryActionChooser: AccessoryActionChooser?
    public var imageViewer: ImageViewer?
    
    // Default implementations if the user does not specifies a custom one.
    public var kDefaultMediaPicker: MediaPicker!
    public var kDefaultImageMessageViewer: ImageViewer!
    public var kDefaultAccessoryActionChooser: AccessoryActionChooser!
    
    // Configuration inner classes
    public let accessoryButton = AccessoryButtonConfig()
    public let avatar = AvatarConfig()
    public let cell = CellConfig()
    
    public static let config = Parla()
    
    fileprivate init() { }
    
    public final class AccessoryButtonConfig {
        public var preventDefault = false
        fileprivate init() { }
    }
    
    public final class AvatarConfig {
//        public var isHidden = false {
//            willSet {
//                if newValue {
//               //     size = CGSize.zero
//                }
//            }
//        }
        public var size: CGSize = AvatarConfig.kDefaultAvatarSize
        public var backgroundColor = AvatarConfig.kDefaultAvatarBackgroundColor
        public var imageContentMode: UIView.ContentMode = .scaleAspectFill
        
        public static let kDefaultAvatarSize = CGSize(width: 30, height: 30)
        public static let kDefaultAvatarBackgroundColor = UIColor.black

        fileprivate init() { }
    }
    
    public final class CellConfig {
        
        // ========
        // Text message bubble color default constant values
        public static let kDefaultBubbleViewOutgoingColor: UIColor = UIColor(withRed: 0.0, green: 122.0, blue: 255.0)
        public static let kDefaultBubbleViewIncomingColor: UIColor = UIColor(withRed: 230.0, green: 229.0, blue: 234.0)
        
        // Effective used variables
        public var textMessageBubbleOutgoingColor = CellConfig.kDefaultBubbleViewOutgoingColor
        public var textMessageBubbleIncomingColor = CellConfig.kDefaultBubbleViewIncomingColor
        // ========
        
        // ========
        // Message text color default constant values
        public static let kDefaultTextIncomingColor = UIColor.black
        public static let kDefaultTextOutgoingColor = UIColor.white
        
        // Effective used variables
        public var textIncomingColor = CellConfig.kDefaultTextIncomingColor
        public var textOutgoingColor = CellConfig.kDefaultTextOutgoingColor
        // ========
        
        // ========
        // Message text color default constant values
        public static let kDefaultVoiceIncomingColor = CellConfig.kDefaultBubbleViewIncomingColor
        public static let kDefaultVoiceOutgoingColor = CellConfig.kDefaultBubbleViewOutgoingColor
        
        // Effective used variables
        public var voiceIncomingColor = CellConfig.kDefaultVoiceIncomingColor
        public var voiceOutgoingColor = CellConfig.kDefaultVoiceOutgoingColor
        
        // ========
        
        public static let kDefaultContentColor = UIColor.black
        public static let kDefaultBackgroundColor = UIColor.white
        
        // Top and bottom label heights
//        public let kDefaultCellBottomLabelHeight: CGFloat = 16
//        public let kDefaultCellTopLabelHeight:CGFloat = 16
        
        public var bottomLabelHeight = 16
        public var topLabelHeight = 16
        
        public let kDefaultBubbleMargins: CGFloat = 35
        public let kDefaultImageBubbleSize: CGSize = CGSize(width: 200, height: 180)
        public let kDefaultVideoBubbleSize: CGSize = CGSize(width: 200, height: 180)
        public let kDefaultVoiceMessageWidth:CGFloat = 200
        public let kDefaultTextFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
        
        public var isBottomLabelHidden:Bool = false
        
        public var sectionInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 0.0, right: 10.0)
        public var labelInsets = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        public var textInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        fileprivate init() {
            
        }
    }
}
