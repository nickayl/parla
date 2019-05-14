//
//  PaddingLabel.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 16/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import UIKit

public protocol CopyableText {
    var canCopyText: Bool { get set }
}

@IBDesignable
public class UIPaddingLabel: UILabel, CopyableText {

    public var  padding: UIEdgeInsets?
    public var canCopyText: Bool = true {
        didSet {
            if canCopyText {
                self.isUserInteractionEnabled = true
                self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(_:))))
            }
        }
    }
    
    @IBInspectable public  var paddingLeft: CGFloat = 0
    @IBInspectable public var paddingRight: CGFloat = 0
    @IBInspectable public var paddingTop: CGFloat = 0
    @IBInspectable public var paddingBottom: CGFloat = 0
    
    override public func drawText(in rect: CGRect) {
        
        if let p = padding {
            super.drawText(in: rect.inset(by: p))
        } else {
            padding = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
            super.drawText(in: rect.inset(by: padding!))
        }
        
    }
    
    @objc public func longPressAction(_ recognizer: UIGestureRecognizer) {
        print("uilabel was long pressed!!")
        
        if  let labelView = recognizer.view,
            let labelSuperview = labelView.superview {
            
                let menuController = UIMenuController.shared
                self.becomeFirstResponder()
                menuController.setTargetRect(labelView.frame, in: labelSuperview)
            // menuController.menuItems = [ UIMenuItem(title: "Copia", action: #selector(self.copyText(_:))) ]
                menuController.setMenuVisible(true, animated:true)
        }
    }
    
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print("===> Inside canPErformAction \(action.description) <===")
        return action == #selector(UIResponderStandardEditActions.copy(_:)) && canCopyText
    }

    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    override public func copy(_ sender: Any?) {
        print("===> Inside copy <===")
        UIPasteboard.general.string = text
        print("copy text: \(text!)")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
