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

public protocol ImageViewer {
    var image: UIImage { get set }
    func show()
    func hide()
    init(withImage image: UIImage, withViewController viewController: UIViewController)
}

public class SKPhotoBrowserImageViewer : ImageViewer {
    
    public var image: UIImage
    
    private var viewController: UIViewController
    private var photo: SKPhoto?
    private var browser: SKPhotoBrowser!
    
    public required init(withImage image: UIImage, withViewController viewController: UIViewController) {
        self.image = image
        self.viewController = viewController
        
    }
    
    public func show() {
        
        if photo == nil {
            photo = SKPhoto.photoWithImage(image)
            browser = SKPhotoBrowser(photos: [photo!])
        }
    
        browser.initializePageIndex(0)
        self.viewController.present(browser, animated: true, completion: nil)
    }
    
    public func hide() {
        browser.determineAndClose()
    }
    
}
