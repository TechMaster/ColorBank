//
//  DetectLabel.swift
//  color
//
//  Created by NhatMinh on 5/15/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import QuartzCore

public class Sniper: UIView {
    
    let circleLineWidth: CGFloat = 3 // your desired value
    let singleLineWidth: CGFloat = 2
    
    public var viewToMagnify: UIView!
    public var touchPoint: CGPoint! {
        didSet {
            self.center = CGPoint(x: touchPoint.x, y: touchPoint.y)
        }
    }
    
    public func initViewToMagnify(viewToMagnify: UIView, touchPoint: CGPoint) {
        
        self.viewToMagnify = viewToMagnify
        self.touchPoint = touchPoint
        
    }
    
      required public convenience init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
            self.init(coder: aDecoder)
    }
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
        self.viewToMagnify = nil
        
        
        let spacing = self.circleLineWidth/2 + self.singleLineWidth*2
        let halfSize: CGFloat = min(bounds.size.width/2, bounds.size.height/2)
        
        drawLine(from: CGPoint(x: halfSize-singleLineWidth/2,y: spacing),
                 to: CGPoint(x: halfSize-singleLineWidth/2,y: halfSize-singleLineWidth),
                 color: UIColor.white)
        drawLine(from: CGPoint(x: halfSize+singleLineWidth/2,y: spacing),
                 to: CGPoint(x: halfSize+singleLineWidth/2,y: halfSize-singleLineWidth),
                 color: UIColor.black)
        
        drawLine(from: CGPoint(x: halfSize-singleLineWidth/2,y: halfSize*2 - spacing),
                 to: CGPoint(x: halfSize-singleLineWidth/2,y: halfSize+singleLineWidth),
                 color: UIColor.black)
        drawLine(from: CGPoint(x: halfSize+singleLineWidth/2,y: halfSize*2 - spacing),
                 to: CGPoint(x: halfSize+singleLineWidth/2,y: halfSize+singleLineWidth),
                 color: UIColor.white)
        
        drawLine(from: CGPoint(x: spacing,y: halfSize-singleLineWidth/2),
                 to: CGPoint(x: halfSize-singleLineWidth,y: halfSize-singleLineWidth/2),
                 color: UIColor.black)
        drawLine(from: CGPoint(x: spacing,y: halfSize+singleLineWidth/2),
                 to: CGPoint(x: halfSize-singleLineWidth,y: halfSize+singleLineWidth/2),
                 color: UIColor.white)
        
        drawLine(from: CGPoint(x: halfSize*2-spacing,y: halfSize-singleLineWidth/2),
                 to: CGPoint(x: halfSize+singleLineWidth,y: halfSize-singleLineWidth/2),
                 color: UIColor.white)
        drawLine(from: CGPoint(x: halfSize*2-spacing,y: halfSize+singleLineWidth/2),
                 to: CGPoint(x: halfSize+singleLineWidth,y: halfSize+singleLineWidth/2),
                 color: UIColor.black)
        
    }
    
    private func setFrame(frame: CGRect) {
        super.frame = frame
        self.layer.cornerRadius = frame.size.width/2
    }
    
    func drawLine(from: CGPoint, to: CGPoint, color: UIColor) {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = singleLineWidth
        
        self.layer.addSublayer(shapeLayer)
    }
    
}
