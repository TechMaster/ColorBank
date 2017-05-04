//
//  colorBar.swift
//  BootStrapDemo
//
//  Created by Loc Tran on 4/25/17.
//  Copyright © 2017 Techmaster Vietnam. All rights reserved.
//

import UIKit

class ColorBar: UIView {
    
    var arrColor: [String]!
    
    init(frame: CGRect, color_0: String, color_1: String, color_2: String, color_3: String, color_4: String ) {
        
        super.init(frame: frame)
        arrColor = [String]()
        arrColor = [color_0,color_1,color_2,color_3,color_4]
        
        let label_0 = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width/5, height: frame.width/5))
        let label_1 = UILabel(frame: CGRect(x: frame.width/5, y: 0, width: frame.width/5, height: frame.width/5))
        let label_2 = UILabel(frame: CGRect(x: frame.width*2/5, y: 0, width: frame.width/5, height: frame.width/5))
        let label_3 = UILabel(frame: CGRect(x: frame.width*3/5, y: 0, width: frame.width/5, height: frame.width/5))
        let label_4 = UILabel(frame: CGRect(x: frame.width*4/5, y: 0, width: frame.width/5, height: frame.width/5))
        
        label_0.backgroundColor = UIColor(hexString: color_0)
        label_1.backgroundColor = UIColor(hexString: color_1)
        label_2.backgroundColor = UIColor(hexString: color_2)
        label_3.backgroundColor = UIColor(hexString: color_3)
        label_4.backgroundColor = UIColor(hexString: color_4)
        
        self.addSubview(label_0)
        self.addSubview(label_1)
        self.addSubview(label_2)
        self.addSubview(label_3)
        self.addSubview(label_4)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getArrColor()->[String]{
        return arrColor
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
