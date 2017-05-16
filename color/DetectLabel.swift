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
    
    init(frame: CGRect, color: UIColor, text: String, caseNo: Int) {
        super.init(frame: frame)
        
        drawLabel(frame: frame, color: color, text: text, caseNo: caseNo)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLabel(frame: CGRect, color: UIColor, text: String, caseNo: Int){
        
        let width = frame.size.width
        let height = frame.size.height
        
        var start = CGPoint(x: 0, y: 0)
        
        var firstPoint = CGPoint()
        var secondPoint = CGPoint()
        var thirdPoint = CGPoint()
        var fourthPoint = CGPoint()
        var fifthPoint = CGPoint()
        var sixthPoint = CGPoint()
        
        switch caseNo {
        case 1: //goc tren trai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width, y: height)
            thirdPoint = CGPoint(x: 0, y: height)
            fourthPoint = CGPoint(x: 0, y: height/5)
            fifthPoint = CGPoint(x: 0-width/5, y: 0)
            sixthPoint = CGPoint(x: 0, y: 0)
            
        case 2: //goc tren phai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width*6/5, y: 0)
            secondPoint = CGPoint(x: width, y: height/5)
            thirdPoint = CGPoint(x: width, y: height)
            fourthPoint = CGPoint(x: 0, y: height)
            fifthPoint = CGPoint(x: 0, y: 0)
            sixthPoint = CGPoint(x: 0, y: 0)
            
        case 3: //goc duoi trai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width, y: height)
            thirdPoint = CGPoint(x: 0-width/5, y: height)
            fourthPoint = CGPoint(x: 0, y: height*4/5)
            fifthPoint = CGPoint(x: 0, y: 0)
            sixthPoint = CGPoint(x: 0, y: 0)
            
        case 4: //goc duoi phai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width, y: height*4/5)
            thirdPoint = CGPoint(x: width*6/5, y: height)
            fourthPoint = CGPoint(x: 0, y: height)
            fifthPoint = CGPoint(x: 0, y: 0)
            sixthPoint = CGPoint(x: 0, y: 0)
            
        case 5: //le trai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width, y: height)
            thirdPoint = CGPoint(x: 0, y: height)
            fourthPoint = CGPoint(x: 0, y: height*2/5)
            fifthPoint = CGPoint(x: 0-width/5, y: height/5)
            sixthPoint = CGPoint(x: 0, y: height/5)
            
        case 6: //le phai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width, y: height/5)
            thirdPoint = CGPoint(x: width*6/5, y: height/5)
            fourthPoint = CGPoint(x: width, y: height*2/5)
            fifthPoint = CGPoint(x: width, y: height)
            sixthPoint = CGPoint(x: 0, y: height)
            
        case 7: //le tren trai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width/5, y: 0)
            secondPoint = CGPoint(x: width/5, y: 0-height/5)
            thirdPoint = CGPoint(x: width*2/5, y: 0)
            fourthPoint = CGPoint(x: width, y: 0)
            fifthPoint = CGPoint(x: width, y: height)
            sixthPoint = CGPoint(x: 0, y: height)
            
        case 8: //le tren phai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width*3/5, y: 0)
            secondPoint = CGPoint(x: width*4/5, y: 0-height/5)
            thirdPoint = CGPoint(x: width*4/5, y: 0)
            fourthPoint = CGPoint(x: width, y: 0)
            fifthPoint = CGPoint(x: width, y: height)
            sixthPoint = CGPoint(x: 0, y: height)
            
        case 9: //ben phai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width, y: height)
            thirdPoint = CGPoint(x: width*4/5, y: height)
            fourthPoint = CGPoint(x: width*4/5, y: height*6/5)
            fifthPoint = CGPoint(x: width*3/5, y: height)
            sixthPoint = CGPoint(x: 0, y: height)
            
        case 10: //ben trai
            start = CGPoint(x: 0, y: 0)
            firstPoint = CGPoint(x: width, y: 0)
            secondPoint = CGPoint(x: width, y: height)
            thirdPoint = CGPoint(x: width*2/5, y: height)
            fourthPoint = CGPoint(x: width/5, y: height*6/5)
            fifthPoint = CGPoint(x: width/5, y: height)
            sixthPoint = CGPoint(x: 0, y: height)
            
        default:
            print("Should not be here")
        }
        
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
