//
//  DrawingViewController2.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 13/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

@IBDesignable
public class UIPaintableImageViewXib : UIView {
    
    @IBOutlet var paintView: UIPaintView!
    @IBOutlet var background: UIImageView!
    
    @IBOutlet var widths: [NSLayoutConstraint]!
    @IBOutlet var heights: [NSLayoutConstraint]!
    
}

@IBDesignable
public class UIPaintableImageView: UIView {

    @IBOutlet public var paintView: UIPaintView!
    @IBOutlet public var background: UIImageView!
    
    @IBOutlet var widths: [NSLayoutConstraint]!
    @IBOutlet var heights: [NSLayoutConstraint]!
    
    private var aspectFitSize: CGSize!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    public var resultImage: UIImage {
        UIGraphicsBeginImageContext(aspectFitSize)
        background.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: aspectFitSize))
        paintView.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: aspectFitSize))
        let img = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return img
    }
    
    private func calculateAspectFitSize() -> CGSize {
        let s = background.image!.size
        let sc = background.image!.scale
        
        let imgSize = CGSize(width: s.width * sc, height: s.height * sc)
        let rectSize = bounds.size
        
        var curWidth = imgSize.width
        var curHeight = imgSize.height
        
        while curWidth > rectSize.width {
            curWidth *= 0.95
            curHeight *= 0.95
        }
        
        while curHeight > (rectSize.height * 0.8) {
            curWidth *= 0.95
            curHeight *= 0.95
            print("resizing height... curheight: \(curHeight)")
        }
        
        let size = CGSize(width: curWidth, height: curHeight)
        print(size)
        
        return size
    }

    private func loadFromNib() {
        let nib = UINib(nibName: "UIPaintableImageView", bundle: Bundle(for: UIPaintableImageView.self))
            .instantiate(withOwner: self, options: nil).first as! UIPaintableImageViewXib
        
        self.widths = nib.widths
        self.heights = nib.heights
        self.paintView = nib.paintView
        self.background = nib.background
        
        nib.subviews.forEach {
            self.addSubview($0)
            
            self.addConstraint(NSLayoutConstraint(item: $0, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: $0, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        }
        
      //  self.addConstraints(nib.constraints)
        
        aspectFitSize = calculateAspectFitSize()
        
        widths.forEach { $0.constant = aspectFitSize.width }
        heights.forEach { $0.constant = aspectFitSize.height }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
