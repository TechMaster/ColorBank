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
    var pos: CGPoint!
    init(frame: CGRect, pos: CGPoint, lineColor: UIColor, bgColor: UIColor, text: String, textColor: UIColor) {
        super.init(frame: frame)
        self.pos = pos
        let screenWidth = UIScreen.main.bounds.size.width
        drawLineThroughPoint(start: pos,
                             throughPoint: [CGPoint(x: pos.x + screenWidth/12, y: pos.y - screenWidth/12),
                                            CGPoint(x: pos.x + screenWidth*7/24, y: pos.y - screenWidth/12),
                                            CGPoint(x: pos.x + screenWidth*7/24, y: pos.y - screenWidth/4),
                                            CGPoint(x: pos.x - screenWidth/12, y: pos.y - screenWidth/4),
                                            CGPoint(x: pos.x - screenWidth/12, y: pos.y - screenWidth/12),
                                            CGPoint(x: pos.x, y: pos.y - screenWidth/12)],
                             endPoint: pos,
                             line: lineColor,
                             color: bgColor,
                             text: text,
                             textColor: textColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLineThroughPoint(start: CGPoint, throughPoint through: [CGPoint], endPoint end:CGPoint, line lineColor: UIColor, color bgColor: UIColor, text: String, textColor: UIColor) {
        
        //design the path
        
        let path = UIBezierPath()
        path.move(to: start)
        for (_, point) in through.enumerated() {
            path.addLine(to: point)
        }
        path.addLine(to: end)
        
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = bgColor.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        
        let textLabel = UILabel()
        textLabel.frame = CGRect(x: through[3].x, y: through[3].y, width: through[2].x - through[3].x, height: through[4].y - through[3].y)
        textLabel.text = text
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.textColor = textColor
        
        self.addSubview(textLabel)
    }
}
