//
//  UIMicrophoneView.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 16/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

public protocol UIMicrophoneViewDelegate {
    func didStartMicrophoneTouch()
    func didEndMicrophoneTouch(withDuration duration: TimeInterval)
}

@IBDesignable
public class UIMicrophoneView: UIView {

    private var view: UIView!
    private var zero: CGRect!
    private var timeCount: TimeInterval = 0.0
    private var isActivityIndicatorVisible: Bool = false
    private let kAdd = CGFloat(2)
    private let kMaxDistance = CGFloat(5)
    
    public var delegate: UIMicrophoneViewDelegate?
    
    @IBOutlet var microphoneButton: UIView!
    
    @IBInspectable var circleColor: UIColor = UIColor(red: 0, green: (122.0/255.0), blue: 1, alpha: 1)
    @IBInspectable var shadowColor: UIColor = UIColor.black
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    @IBInspectable var shadowOpacity: Float = 0.6
    @IBInspectable var shadowRadius: Float = 10
    
    public override func awakeFromNib() {
        let cx = (frame.size.width + kAdd)/2
        let cy = (frame.size.height + kAdd)/2
        
        self.zero = CGRect(x: cx, y: cy, width: 0, height: 0)
        self.view = UIView(frame: zero)
        view.backgroundColor = circleColor
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowRadius = CGFloat(shadowRadius)
        view.layer.shadowOpacity = Float(shadowOpacity)
        self.insertSubview(view, at: 0)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touch start")
        
        timeCount = 0
        updateTimeCount()
        show()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touch end")
        
        updateTimeCount()
        hide()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        updateTimeCount()
        hide()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let l = touches.first!.location(in: self)

        print("Location: \(l.x) \(l.y) == ")
        
        if isOutOfRange(point: l) {
            hide()
            print("Out of range")
        }
        
    }
    
    private func isOutOfRange(point p: CGPoint) -> Bool {
        return (p.x > (bounds.width + kMaxDistance) || p.x  <  -kMaxDistance)
            || (p.y > (bounds.height + kMaxDistance) || p.y <  -kMaxDistance)
    }
    
    private func updateTimeCount() {
        timeCount = Date().timeIntervalSince1970 - timeCount
    }
    
    private func hide() {
        if !isActivityIndicatorVisible { return }
        
        UIView.animate(withDuration: 0.2) {
            self.view.bounds = self.zero
            self.view.alpha = 0
        }
        
        isActivityIndicatorVisible = false
        self.delegate?.didEndMicrophoneTouch(withDuration: timeCount)
    }
    
    private func show() {
        if isActivityIndicatorVisible { return }
        
        UIView.animate(withDuration: 0.2) {
            self.view.frame = CGRect(x: -(self.kAdd+4), y: -(self.kAdd), width: self.frame.width + self.kAdd, height: self.frame.height + self.kAdd)
            self.view.alpha = 1
            self.view.layer.cornerRadius = ((self.frame.width + self.kAdd)/2)
        }
        
        isActivityIndicatorVisible = true
        self.delegate?.didStartMicrophoneTouch()
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
