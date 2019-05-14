//
//  DrawingViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 13/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

class UIDrawingView : UIImageView {
    
    private var lineWidth = 10
    private var lastPoint: CGPoint!
    public var lineColor: CGColor = UIColor.green.cgColor
    public var blendMode: CGBlendMode = .normal
    public var calcSize:CGSize!
    
    private var topBottompadding: CGFloat!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       print("Touches began")
        calcSize = calculateAspectFitSize()
        
        lastPoint = touches.first?.location(in: self)
        
     //   UIGraphicsBeginImageContextWithOptions(frame.size, false, CGFloat(1.0))
    }
    
    public var isize: CGSize!
    public var imgScale: CGFloat!
    
    private func calculateAspectFitSize() -> CGSize {
        let s = isize
        let sc = imgScale
        
        let imgSize = CGSize(width: s!.width * sc!, height: s!.height * sc!)
        let rectSize = self.bounds.size
        
        var curWidth = imgSize.width
        var curHeight = imgSize.height
        
        while curWidth > rectSize.width {
            curWidth *= 0.9
            curHeight *= 0.9
        }
        
        let size = CGSize(width: curWidth, height: curHeight)
        print(size)
        
        topBottompadding  = CGFloat((rectSize.height - imgSize.height)/2)
        
        return size
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches moved")
        
        
        
        let touch = touches.first!
        var loc = touch.location(in: self)
        
        loc = CGPoint(x: 0, y: 0)
        
        print(loc)
        
        UIGraphicsBeginImageContext(calcSize)
        let context = UIGraphicsGetCurrentContext()!
        
        
        self.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size:self.image!.size))
        
        context.move(to: lastPoint)
        context.addLine(to: loc)
//        context.setFillColor(UIColor.clear.cgColor)
//        context.fill(bounds)
        context.setLineCap(.round)
        context.setBlendMode(blendMode)
        context.setLineWidth(CGFloat(lineWidth))
        context.setStrokeColor(lineColor)
        context.strokePath()
        
        self.image = UIImage(cgImage: context.makeImage()!)
        
        UIGraphicsEndImageContext()
        lastPoint = loc
      //  context.fillEllipse(in: CGRect(x: loc.x, y: loc.y, width: 20, height: 20))
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches ended")
        lastPoint = touches.first?.location(in: self)
        
    }

//    public func getResult() -> UIImage {
//
//    }
}

class DrawingViewController: UIViewController {

    @IBOutlet var imageView: UIDrawingView!
    
    @IBOutlet var resultImageview: UIImageView!
    
    private var img = UIImage(named: "doc.jpg")!
    
    @IBAction func ok(_ sender: Any) {
        UIGraphicsBeginImageContext(img.size)
        img.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: img.size))
        imageView.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: img.size))
        resultImageview.image = UIImage(cgImage: UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
    }
    
    @IBOutlet var ereaser: UIButton!
    @IBOutlet var red: UIButton!
    @IBOutlet var green: UIButton!
    
    
    @IBAction func greenColor(_ sender: Any) {
        imageView.lineColor = UIColor.green.cgColor
        imageView.blendMode = .normal
    }
    
    @IBAction func redColor(_ sender: Any) {
       imageView.lineColor = UIColor.red.cgColor
        imageView.blendMode = .normal
    }
    
    @IBAction func ereaser(_ sender: Any) {
        imageView.lineColor = UIColor.clear.cgColor
        imageView.blendMode = .clear
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isize = img.size
        imageView.imgScale = img.scale
        
//        let size = CGSize(width: 150, height: 150)
//        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(1.0))
//
//        if let context = UIGraphicsGetCurrentContext() {
//            context.fill(CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//            let layer = CGLayer(context, size: size, auxiliaryInfo: nil)
//            context.setFillColor(UIColor.green.cgColor)
//            context.fillEllipse(in: CGRect(x: 0, y: 0, width: 50, height: 50))
//            context.draw(layer!, in: CGRect(x: 0, y: 0, width: 50, height: 50))
//            imageView.image = UIImage(cgImage: context.makeImage()!)
       // }
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: 150, height: 150), false, CGFloat(1.0))
//
//        if let context = UIGraphicsGetCurrentContext() {
//            context.setFillColor(UIColor.red.cgColor)
//            context.fill(CGRect(x: 0, y: 0, width: 50, height: 50))
//            context.setFillColor(UIColor.green.cgColor)
//            context.fill(CGRect(x: 51, y: 51, width: 50, height: 50))
//            context.setFillColor(UIColor.blue.cgColor)
//            context.fillEllipse(in: CGRect(x: 0, y: 51, width: 50, height: 50))
//            context.setFillColor(UIColor.purple.cgColor)
//            context.fillEllipse(in: CGRect(x: 51, y: 0, width: 50, height: 50))
//            let img = UIImage(cgImage: context.makeImage()!)
//
//            imageView.image = img
//        }
        
//        if let img = UIGraphicsGetImageFromCurrentImageContext() {
//            imageView.image = img
//        }
        

        // Do any additional setup after loading the view.
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
