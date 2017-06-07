//
//  ColorListCell.swift
//  color
//
//  Created by NhatMinh on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class ColorListCell: UITableViewCell{
    
    var cell: ColorBar!
    var color0 = String()
    var color1 = String()
    var color2 = String()
    var color3 = String()
    var color4 = String()
    var name = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
