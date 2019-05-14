//
//  UIPaintView.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 14/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
public class UIPaintView : UIImageView {
    
    @IBInspectable public var lineWidth: Int = 10
    @IBInspectable public var lineColor: UIColor = UIColor.green {
        didSet {
            self.lineCGColor = lineColor.cgColor
            if lineColor == UIColor.clear {
                blendMode = .clear
            } else {
                blendMode = .normal
            }
        }
    }
    
    private var blendMode: CGBlendMode = .normal
    private var lastPoint: CGPoint!
    private var lineCGColor: CGColor!
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches began")
        
        UIGraphicsBeginImageContext(self.bounds.size)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)
        context.setBlendMode(blendMode)
        context.setLineWidth(CGFloat(lineWidth))
        context.setStrokeColor(lineColor.cgColor)
        
        lastPoint = touches.first?.location(in: self)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches moved")
        
        let touch = touches.first!
        let loc = touch.location(in: self)
        
        print(loc)
        
        let context = UIGraphicsGetCurrentContext()!
        
        self.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size:self.image!.size))
        
        context.move(to: lastPoint)
        context.addLine(to: loc)
        context.strokePath()
        
        self.image = UIImage(cgImage: context.makeImage()!)
        
        lastPoint = loc
    }
    
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches ended")
        UIGraphicsEndImageContext()
        lastPoint = touches.first?.location(in: self)
    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //
    //        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
    //
    //        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
    //
    //        self.addConstraints([heightConstraint, widthConstraint])
    //    }
    
}
