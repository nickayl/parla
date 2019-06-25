//
//  ImageViewer.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import UIKit
import SKPhotoBrowser

@objc public protocol ImageViewer {
   // var image: UIImage { get set }
    func show(image: UIImage, in viewController: UIViewController)
    func hide()
  //  init(withImage image: UIImage, withViewController viewController: UIViewController)
}

@objc public class SKPhotoBrowserImageViewer : NSObject, ImageViewer {
    
   // public var image: UIImage
    // private var photo: SKPhoto?
    
    private var viewController: UIViewController?
    private var browser: SKPhotoBrowser?
    private static var instance: ImageViewer?
    
    
    private override init() {
    }
    
    public static func getInstance() -> ImageViewer {
        if instance == nil {
            instance = SKPhotoBrowserImageViewer()
        }
        return instance!
    }
    
//    public required init(withImage image: UIImage, withViewController viewController: UIViewController) {
//        self.image = image
//        self.viewController = viewController
//    }
    
    public func show(image: UIImage, in viewController: UIViewController) {
        
        let photo = SKPhoto.photoWithImage(image)
        
        if browser == nil {
            self.browser = SKPhotoBrowser(photos: [photo])
        } else {
            browser?.photos.removeAll()
            browser?.addPhotos(photos: [photo])
        }
        
        browser?.initializePageIndex(0)
        viewController.present(browser!, animated: true, completion: nil)
    }
    
    public func hide() {
        browser?.determineAndClose()
    }
    
}
