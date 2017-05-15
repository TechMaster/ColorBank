//
//  DetectLabel.swift
//  color
//
//  Created by NhatMinh on 5/15/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import Foundation
import UIKit

class DetectLabel: SRCopyableLabel {
    
    init(frame: CGRect, color: UIColor, text: String) {
        super.init(frame: frame)
        
        drawLabel(frame: frame, color: color, text: text)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLabel(frame: CGRect, color: UIColor, text: String){
        
        let width = frame.size.width
        let height = frame.size.height
        
        let start = CGPoint(x: 0, y: 0)
        
        let firstPoint = CGPoint(x: width, y: 0)
        let secondPoint = CGPoint(x: width, y: height)
        let thirdPoint = CGPoint(x: width*2/5, y: height)
        let fourthPoint = CGPoint(x: width/5, y: height*6/5)
        let fifthPoint = CGPoint(x: width/5, y: height)
        let sixthPoint = CGPoint(x: 0, y: height)
        
        let throughPoints = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint, sixthPoint]
        
        //design the path
        
        let path = UIBezierPath()
        path.move(to: start)
        for (_, point) in throughPoints.enumerated() {
            path.addLine(to: point)
        }
        path.addLine(to: start)
        
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        if color.isLight() == true {
            shapeLayer.strokeColor = UIColor.black.cgColor
        }else{
            shapeLayer.strokeColor = UIColor.white.cgColor
        }
        
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = color.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        let textLabel = SRCopyableLabel()
        textLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
        textLabel.text = text
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        
        if color.isLight() == true {
            textLabel.textColor = UIColor.black
        }else{
            textLabel.textColor = UIColor.white
        }
        
        self.addSubview(textLabel)
        
        
    }
    
}
