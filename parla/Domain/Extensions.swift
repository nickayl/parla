//
//  Extensions.swift
//  doctorchat
//
//  Created by Domenico Gabriele Aiello on 16/01/17.
//  Copyright © 2017 Doctor Chat S.r.l. All rights reserved.
//

import Foundation
import UIKit
import CoreMedia
import AVFoundation

extension UIColor {
    
    convenience init(withRed red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
    }
    
}

extension String {

    /**
     Check if the string is a valid url
     */
    public func isURL() -> Bool {
        return URL(string: self) != nil
    }
    
    public func length() -> Int {
        return self.count
    }
    
    func height(with width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return actualSize.height
    }
    
    public func isImage() -> Bool {
        let imageFormats = ["jpg", "jpeg", "png", "gif"]
        
        if let ext = self.getExtension() {
            if imageFormats.contains(ext) {
                print("\(self) is a \(ext) image.")
                return true
            }
        }
        
        print("\(self) is not an image ")
        return false
    }
    
    public func isVideo() -> Bool {
        
        let videoFormats = ["mp4", "mov", "m4v", "avi"]
        
        if let ext = self.getExtension() {
            if videoFormats.contains(ext) {
                print("\(self) is a \(ext) video")
                return true
            }
        }
        
        print("\(self) is not a video ")
        return false
    }
    
    private func getExtension() -> String? {
        /* if let lastIndexOf = self.lastIndex(of: ".") {
         
         let ext = self.substring(from: self.index(self.startIndex, offsetBy: lastIndexOf.advanced(by: 1)))
         print("\(ext)")
         
         return ext
         } */
        
        let ext = (self as NSString).pathExtension
        
        return ext.isEmpty ? nil : ext
        
 /*       if ext.isEmpty {
            return nil
        }
        
        return ext */
    }
    
    func lastIndex(of target: String) -> IndexDistance? {
        if let range = self.range(of: target, options: .backwards) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
}

extension UIImage {
    
    /**
     Returns an UIImage with a specified background color.
     - parameter color: The color of the background
     */
    convenience init(withBackground color: UIColor) {
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.setFillColor(color.cgColor);
        context.fill(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(ciImage: CIImage(image: image)!)
        
    }
}

@objc extension UIButton {
    
    public func setBackgroundColor(color: UIColor, forState state: UIControl.State) -> UIButton {
        self.setBackgroundImage(UIImage(withBackground: color), for: state)
        return self
    }
    
//    @objc public override func setBorderRadius(radius: Int) {
//        self.layer.cornerRadius = CGFloat(radius)
//        self.layer.masksToBounds = true
//    }
}

extension UIView {
    
    /**
     Hide the view with the specified duration.
     This method will set the alpha value to 0.
     
     - parameter duration: The duration of the hide animation.
     
     */
    public func hide(withDuration duration: Double) {
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.alpha = 0.0
        }
    }
    
    public func show(withDuration duration: Double) {
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.alpha = 1.0
        }
    }
    
    public func setBorderRadius(radius: Int) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
    }
    
   
}

extension UICollectionView {
    
    public func scrollToBottom(animated: Bool) {
        let section = self.numberOfSections - 1
        let numberOfItemsInSection = self.numberOfItems(inSection: section) - 1
        self.scrollToItem(at: IndexPath(item: numberOfItemsInSection, section: section), at: .bottom , animated: animated)
    }
    
}

public class Utils {
    
    public static func thumbnailImageForVideo(withUrl url: URL, atTime time:TimeInterval) -> UIImage? {
        
        let asset: AVURLAsset = AVURLAsset(url: url, options: nil)
        
        let assetIG: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        
        var image:CGImage?
        
        do {
            image = try assetIG.copyCGImage(at: CMTimeMake(value: Int64(time), timescale: 60), actualTime: nil)
           /* assetIG.generateCGImagesAsynchronously(forTimes: [ NSValue(time: CMTimeMake(Int64(time), 60)) ],
                                                   completionHandler: { (requestedTime, cgImage, actualTime, result, error) in
                print("Asset load complete: \(result) error=\(error)")
                                            
            }) */ 
        } catch {
            print("error in getting thumb image from video \(error)")
            return nil
        }
        
        if image != nil {
            return UIImage(cgImage: image!)
        }
        
        return nil
    }
    
}

extension URL {
    
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
/*
 
 + (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
 atTime:(NSTimeInterval)time
 {
 
 AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
 NSParameterAssert(asset);
 AVAssetImageGenerator *assetIG =
 [[AVAssetImageGenerator alloc] initWithAsset:asset];
 assetIG.appliesPreferredTrackTransform = YES;
 assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
 
 CGImageRef thumbnailImageRef = NULL;
 CFTimeInterval thumbnailImageTime = time;
 NSError *igError = nil;
 thumbnailImageRef =
 [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
 actualTime:NULL
 error:&igError];
 
 if (!thumbnailImageRef)
 NSLog(@"thumbnailImageGenerationError %@", igError );
 
 UIImage *thumbnailImage = thumbnailImageRef
 ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
 : nil;
 
 return thumbnailImage;
 }
 */

