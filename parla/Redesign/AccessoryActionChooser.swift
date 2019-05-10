//
//  AccessoryActionChooser.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 10/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import UIKit

//@objc public enum AccessoryAction : Int {
//    case choosePhotoFromGallery
//    case chooseVideoFromGallery
//    case pickPhotoFromCamera
//    case pickVideoFromCamera
//}


@objc public enum AccessoryActionType: Int {
    case chooseImageFromGallery = 0
    case chooseVideoFromGallery = 1
    case pickImageFromCamera = 2
    case pickVideoFromCamera = 3
}

//@objc public protocol AccessoryAction {
//    var type: AccessoryActionType { get }
//    var content: Any? { get }
//    func executeAction()
//}

//@objc public class AccessoryActionImpl : NSObject, AccessoryAction {
//
//    public var type: AccessoryActionType
//    private var action: () -> Any?
//    public var content: Any?
//
//    public init(type: AccessoryActionType, content: Any? = nil, action: @escaping () -> Any?) {
//        self.type = type
//        self.action = action
//        self.content = content
//    }
//
//    public func executeAction() {
//        self.content = action()
//    }
//}

public typealias AccessoryAction = () -> Void

@objc public protocol AccessoryActionChooserDelegate {
    func didChooseAccessoryAction(with action: AccessoryAction?, ofType type: AccessoryActionType)
    @objc optional func didPresentedAccessoryChooser()
    @objc optional func didDismissedAccessoryChooser()
}

public protocol AccessoryActionChooser {
    var accessoryActions: [ AccessoryActionType : AccessoryAction ] { get set }
    var delegate: AccessoryActionChooserDelegate? { get set }
    func show()
    func dismiss()
}

public class ActionSheetAccessoryActionChooser : AccessoryActionChooser {
    
   // public var accessoryActions: [AccessoryAction] = []
    public var accessoryActions: [AccessoryActionType : AccessoryAction] = [:]
    public var delegate: AccessoryActionChooserDelegate?
    private var viewController: UIViewController
    private let alert: UIAlertController
    private var config: Parla!
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        self.config = Parla.config!
        
        alert = UIAlertController(title: "Add media chooser", message: "Add photos and videos", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Choose Photo", comment: "Default action"), style: .default, handler: { _ in
            let action = self.accessoryActions[.chooseImageFromGallery]
            self.delegate?.didChooseAccessoryAction(with: action, ofType: .chooseImageFromGallery)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Pick Photo", comment: "Default action"), style: .default, handler: { _ in
             let action = self.accessoryActions[.pickImageFromCamera]
            self.delegate?.didChooseAccessoryAction(with: action, ofType: .pickImageFromCamera)
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Choose video", comment: "Default action"), style: .default, handler: { _ in
             let action = self.accessoryActions[.chooseVideoFromGallery]
            self.delegate?.didChooseAccessoryAction(with: action, ofType: .chooseVideoFromGallery)
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Pick video", comment: "Default action"), style: .default, handler: { _ in
             let action = self.accessoryActions[.pickVideoFromCamera]
             self.delegate?.didChooseAccessoryAction(with: action, ofType: .pickVideoFromCamera)
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .destructive, handler: { _ in
            
        }))
    }
    
    public func show() {
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public func dismiss() {
        alert.dismiss(animated: true, completion: nil)
    }
    
    
}
//            self.accessoryActions.filter {
//                return $0.type == .chooseImageFromGallery
//            }.forEach {
//                self.delegate?.didChooseAccessoryAction(with: $0)
//            }
