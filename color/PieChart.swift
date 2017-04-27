//
//  PieChartView.swift
//  BootStrapDemo
//
//  Created by Ledung95d on 4/25/17.
//  Copyright © 2017 Techmaster Vietnam. All rights reserved.
//

import UIKit

class PieChart: UIView {
    
    var arrColor: [UIColor]!
    init(frame: CGRect,arrColor: [UIColor]) {
        super.init(frame: frame)
        self.arrColor = arrColor
        self.backgroundColor = UIColor.white
    }
    var cvRadians = {(deg: CGFloat)->CGFloat in
        return CGFloat(deg * CGFloat(M_PI) / 180)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        var startAngle: CGFloat = -90.0
        let pieAngle: CGFloat = 360 / CGFloat(self.arrColor.count-1)
        
        let center = CGPoint(x: rect.maxX/2, y: rect.maxY/2)
        for i in 0..<self.arrColor.count-1{
            
            
            ctx?.setLineWidth(4)
            ctx?.move(to: CGPoint(x: rect.maxX/2, y: rect.maxY/2))
            ctx?.addArc(center: center, radius: self.frame.width/3, startAngle: cvRadians(startAngle), endAngle: cvRadians(startAngle + pieAngle), clockwise: false)
            ctx!.setFillColor(arrColor[i].cgColor)
            ctx?.fillPath()
            startAngle = startAngle + pieAngle
        }
        ctx?.addArc(center: center, radius: self.frame.width/6, startAngle: cvRadians(0), endAngle: cvRadians(360), clockwise: false)
        ctx!.setFillColor(arrColor.last!.cgColor)
        ctx?.fillPath()
        
    }
    
}
