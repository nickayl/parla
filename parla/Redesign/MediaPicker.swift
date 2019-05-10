//
//  ImagePicker.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 10/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

public enum MediaPickerSource {
    case photoLibrary
    case camera
}

public protocol MediaPicker : ImagePicker, VideoPicker {
   // func pickMedia(completitionHandler: (_ image: Any?) -> Void)
}

public protocol ImagePicker {
    func pickImage(source: MediaPickerSource, completitionHandler: @escaping (_ image: UIImage?) -> Void)
}

public protocol VideoPicker {
    func pickVideo(source: MediaPickerSource, completitionHandler: @escaping (_ videoUrl: URL?) -> Void)
}

public class SystemMediaPicker : NSObject, MediaPicker, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewController: UIViewController!
    var completitionHandler: ((UIImage?) -> Void)?
    private var imagePickerController: UIImagePickerController
    private var videoCompletitionHandler: ((URL?) -> Void)?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        imagePickerController = UIImagePickerController()
        super.init()
        imagePickerController.delegate = self
    }
    
    public func pickImage(source: MediaPickerSource,  completitionHandler: @escaping (UIImage?) -> Void) {
        self.completitionHandler = completitionHandler
        imagePickerController.sourceType = (source == .photoLibrary ? .photoLibrary : .camera)
        imagePickerController.mediaTypes = [(kUTTypeImage as NSString) as String]
        
        self.viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    public func pickVideo(source: MediaPickerSource, completitionHandler: @escaping (URL?) -> Void) {
        self.videoCompletitionHandler = completitionHandler
        imagePickerController.sourceType = (source == .photoLibrary ? .photoLibrary : .camera)
        imagePickerController.mediaTypes = ["public.movie"]
        
        self.viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(onSavingImageError(_:didFinishSavingWithError:contextInfo:)), nil)
            completitionHandler?(image)
        } else {
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                videoCompletitionHandler?(videoURL)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func onSavingImageError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Some error occurred during save image... \(error)")
    }
    

//    var videoURL: URL?
//
//    private func openImgPicker() {
//        imagePickerController.sourceType = .savedPhotosAlbum
//        imagePickerController.delegate = self
//        imagePickerController.mediaTypes = ["public.movie"]
//        present(imagePickerController, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
//        print(" =====> videoURL:\(String(describing: videoURL)) < ========")
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
}
