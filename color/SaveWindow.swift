//
//  SaveView.swift
//  color
//
//  Created by Loc Tran on 6/1/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class SaveWindow: UIView {

    var doneButton = UIButton()
    var textField = UITextField()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.cyan
        
    }
    
    func createDoneButton(){
        doneButton.frame = CGRect(x: self.bounds.size.width/2 - self.bounds.size.width/6,
                                  y: self.bounds.size.height*5/8 , width: self.bounds.size.width/3, height: self.bounds.size.height/4)
        
        doneButton.backgroundColor = UIColor.black
        self.addSubview(doneButton)
    }
    
    func createTextField(){
        textField.frame = CGRect(x: self.bounds.size.width/6, y: self.bounds.size.height/8, width: self.bounds.size.width*2/3, height: self.bounds.height/4)
        
        textField.placeholder = "Please enter palette name here."
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.white
        textField.clearsOnInsertion = true
        
        self.addSubview(textField)
    }
    
    
}
