//
//  ScreenA.swift
//  BootStrapDemo
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DetailColorVC: UIViewController {
    
    var colorArr: [ColorItem]!
    var indexSection: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let arr:[String] = colorArr[indexSection].colorArray
        
        let frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.width)
        
        let chart = PieChart(frame: frame , arrColor: self.getUIColor(arr: arr))
        self.view.addSubview(chart)
        self.view.addSubview(drawInfo(arr: arr))
        
    }
    
    func getUIColor(arr: [String])->[UIColor]{
        var cl : [UIColor] = []
        for color in arr{
            cl.append(UIColor(hexString: color))
        }
        return cl
    }
    
    func drawInfo(arr: [String])->UIView{
        let infoView = UIView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
        let _height = (infoView.frame.height-64)/5
        for i in 0..<arr.count{
            let label = UILabel(frame: CGRect(x: 0, y:64+CGFloat(i)*_height, width: infoView.frame.width, height:_height))
            label.text = arr[i]
            label.textAlignment = .center
            label.backgroundColor = UIColor(hexString: arr[i])
            
            infoView.addSubview(label)
        }
        return infoView
        
        
    }
}

