//
//  DetectLabel.swift
//  color
//
//  Created by NhatMinh on 5/15/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import Foundation
import UIKit

class DetectLabel: UIView {
    
    var halfSize: CGFloat!
    let circleLineWidth: CGFloat = 3 // your desired value
    let singleLineWidth: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let spacing = self.circleLineWidth/2 + self.singleLineWidth*2
        
        halfSize = min(bounds.size.width/2, bounds.size.height/2)
        
        
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
        
        drawCirlce()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawCirlce(){
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:halfSize,y:halfSize),
                                      radius: CGFloat( halfSize - (circleLineWidth/2) ),
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(M_PI * 2),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = circleLineWidth
        
        self.layer.addSublayer(shapeLayer)
        
        
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
