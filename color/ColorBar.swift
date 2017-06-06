//
//  colorBar.swift
//  BootStrapDemo
//
//  Created by Loc Tran on 4/25/17.
//  Copyright © 2017 Techmaster Vietnam. All rights reserved.
//

import UIKit

class ColorBar: UIView {
    
    init(frame: CGRect, color_0: String, color_1: String, color_2: String, color_3: String, color_4: String ) {
        
        super.init(frame: frame)
        
        
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
    
}
