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

public extension UIColor {
    
    convenience init(withRed red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
    }
    
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

public extension String {
    
    
    /**
     Check if the string is a valid url
     */
    func isURL() -> Bool {
        return URL(string: self) != nil
    }
    
    func length() -> Int {
        return self.count
    }
    
    func height(with width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(actualSize.height)
    }
    
    func isImage() -> Bool {
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
    
    func isVideo() -> Bool {
        
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
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

}

public extension UIImage {
    
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

@objc public extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState state: UIControl.State) -> UIButton {
        self.setBackgroundImage(UIImage(withBackground: color), for: state)
        return self
    }
    
//    @objc public override func setBorderRadius(radius: Int) {
//        self.layer.cornerRadius = CGFloat(radius)
//        self.layer.masksToBounds = true
//    }
}

public extension UIView {
    
    /**
     Hide the view with the specified duration.
     This method will set the alpha value to 0.
     
     - parameter duration: The duration of the hide animation.
     
     */
     func hide(withDuration duration: Double = 0.2) {
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.alpha = 0.0
        }
    }
    
     func show(withDuration duration: Double = 0.2) {
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.alpha = 1.0
        }
    }
    
     func setBorderRadius(radius: Int) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
    }
   
}

public extension UICollectionView {
    
     func scrollToBottom(animated: Bool) {
        let section = self.numberOfSections - 1
        let numberOfItemsInSection = self.numberOfItems(inSection: section) - 1
        self.scrollToItem(at: IndexPath(item: numberOfItemsInSection, section: section), at: .bottom , animated: animated)
    }
    
}

public class Utils {
    
    public static func getModelNumber() -> (Int, Int) {
        let submodel: [String.SubSequence] = UIDevice.current.modelName.replacingOccurrences(of: "iPhone", with: "").split(separator: ",")
        
        if submodel.count == 2 {
            let modelNumber = Int(submodel[0])
            let secondNumber = Int(submodel[1])
            
            print("Submodel: \(submodel) - modelNumber: \(modelNumber) - secondNumber: \(secondNumber)")
            return (modelNumber!, secondNumber!)
        }
        return  (11, 11)
    }
    
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

public extension URL {
    
    static var documentsDirectory: URL {
        let paths = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return paths
    }
    
}

internal extension Date {
    
    static func fromString(_ string: String, withFormat format: String = getDateTimeFormat()) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: string)
    }
    
    func toString(withFormat format: String = getDateTimeFormat()) -> String? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
    
    static func getDateTimeFormat() -> String {
        // 06/01/2019 10:04:20
        
        return "dd_MM_yyyy__H_mm_ss"
        //   return "yyyy-MM-dd hh:mm:ss"
    }
    
    static func getDateFormat() -> String {
        return "dd_MM_yyyy"
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

