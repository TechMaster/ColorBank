//
//  ChosenImageVC.swift
//  color
//
//  Created by NhatMinh on 4/28/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import Foundation
import UIKit
import Fusuma

class ChosenImageVC: UIViewController, PassingDetectColorDelegate {
    
    let magView = YPMagnifyingView()
    var imageView = UIImageView()
    var image = UIImage()
    var getColorButton = UIButton()
    var paletteView = UIView()
    var customPalette = [UILabel]()
    var customPaletteHexArray = [String]()
    let descriptionLabel = DescriptionLabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = fusumaBackgroundColor
        self.navigationController?.navigationBar.barTintColor = fusumaBackgroundColor
        self.navigationController?.navigationBar.tintColor = fusumaTintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: fusumaTintColor]
        
        magView.delegate = self
        
        createMagGlassAndSniper()
        createGetColorButton()
        createCustomPaletteView()
        createUndoButton()

    }
    
    func createImageView() {
        
        imageView.frame = self.magView.bounds
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
    }
    
    func createMagGlassAndSniper(){
        
        let navHeight = self.navigationController?.navigationBar.bounds.size.height
        let screenWidth = self.view.bounds.size.width
        let statusHeight = UIApplication.shared.statusBarFrame.height
        
        magView.frame = CGRect(x: 10, y: navHeight! + statusHeight + 10, width: screenWidth - 20, height: screenWidth - 20)
        magView.layer.borderWidth = 1
        magView.layer.borderColor = UIColor.black.cgColor
        
        createImageView()
        
        
        let magGlass = YPMagnifyingGlass(frame: CGRect(x: magView.frame.origin.x, y: magView.frame.origin.y, width: 55, height: 55))
        magGlass.layer.cornerRadius = 8
        magGlass.scale = 4
        magView.magnifyingGlass = magGlass
        
        let focusPoint = YPMagnifyingGlass(frame: CGRect(x: magView.frame.origin.x, y: magView.frame.origin.y, width: 20, height: 20))
        focusPoint.layer.cornerRadius = focusPoint.frame.width/2
        focusPoint.scale = 8
        magView.focusPoint = focusPoint
        
        let sniper = Sniper(frame: CGRect(x: magView.frame.origin.x, y: magView.frame.origin.y, width: 30, height: 30))
        magView.sniper = sniper
        
        self.view.addSubview(magView)
        magView.addSubview(imageView)
        
    }
    
    func createCustomPaletteView() {
        let paletteViewWidth = self.magView.bounds.size.width
        let paletteViewHeight = self.view.bounds.size.height - 15 - self.getColorButton.bounds.size.height - self.magView.frame.maxY
        paletteView.frame = CGRect(x: self.magView.frame.minX,
                                   y: self.magView.frame.maxY,
                                   width: paletteViewWidth,
                                   height: paletteViewHeight)
        
        paletteView.layer.borderWidth = 1
        paletteView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(paletteView)
        
        descriptionLabel.frame = self.paletteView.bounds
        descriptionLabel.text = "Press the button below to pick color for your palette."
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.layer.zPosition = -1
        
        self.paletteView.addSubview(descriptionLabel)
        
        
    }
    
    func passColor(hexString: String) {
        getColorButton.backgroundColor = UIColor(hexString: hexString)
        getColorButton.setTitle(hexString, for: .normal)
        if UIColor(hexString: hexString).isLight() == true {
            getColorButton.titleLabel?.textColor = UIColor.black
        }else{
            getColorButton.titleLabel?.textColor = UIColor.white
        }
    }
    
    
    func createGetColorButton(){
        
        let buttonWidth = (self.view.bounds.size.height - self.magView.frame.maxY)/2 - 15
        
        getColorButton.frame = CGRect(x: self.view.bounds.size.width/2 - buttonWidth/2,
                                      y: self.view.bounds.size.height - buttonWidth - 7.5,
                                      width: buttonWidth,
                                      height: buttonWidth)
        getColorButton.backgroundColor = UIColor.black
        getColorButton.layer.cornerRadius = buttonWidth/2
        getColorButton.addTarget(self, action: #selector(updateColorForPalette), for: .touchUpInside)
        self.view.addSubview(getColorButton)
    }
    
    func updateColorForPalette() {
        
        self.descriptionLabel.isHidden = true
        
        if customPalette.count < 5 {
            let screenWidth = self.view.bounds.size.width
            let paletteViewWidth = self.paletteView.bounds.size.width
            let paletteViewHeight = self.paletteView.bounds.size.height
            let newColor = UILabel()
            newColor.frame = CGRect(x: screenWidth*6/5,
                                    y: paletteView.frame.minY,
                                    width: paletteViewWidth/5,
                                    height: paletteViewHeight)
            newColor.backgroundColor = getColorButton.backgroundColor
            newColor.layer.borderWidth = 2
            newColor.layer.borderColor = getColorButton.backgroundColor?.cgColor
            customPalette.append(newColor)
            customPaletteHexArray.append((newColor.backgroundColor?.toHexString)!)
            self.view.addSubview(newColor)
            
            UIView.animate(withDuration: 1, animations: {
                newColor.center.x = self.magView.frame.minX + self.paletteView.bounds.size.width*(CGFloat(self.customPalette.count)/5) - (newColor.frame.size.width/2)
            })
        }
    }
    
    func createSaveButton(){
        
        let buttonWidth = (self.view.bounds.size.height - self.magView.frame.maxY)/2 - 15

        let saveButton = UIButton()
        saveButton.frame = CGRect(x: self.view.bounds.size.width - buttonWidth - 10,
                                  y: self.view.bounds.size.height - buttonWidth - 7.5,
                                  width: buttonWidth,
                                  height: buttonWidth)
        saveButton.backgroundColor = UIColor.red
        saveButton.addTarget(self, action: #selector(saveImageAction), for: .touchUpInside)
        self.view.addSubview(saveButton)
    }
    
    func saveImageAction(){
        
    }
    
    func createUndoButton(){
        let undoButton = UIButton()
        
        let buttonWidth = (self.view.bounds.size.height - self.magView.frame.maxY)/2 - 15
        
        undoButton.frame = CGRect(x: 10,
                                  y: self.view.bounds.size.height - buttonWidth - 7.5,
                                  width: buttonWidth,
                                  height: buttonWidth)
        undoButton.backgroundColor = UIColor.blue
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        self.view.addSubview(undoButton)
        
    }
    
    func undo(){
       
    }
    
}

extension UIColor {
    func isLight() -> Bool
    {
        let components = self.cgColor.components
        let brightness = ((((components?[0])! * 299.0) as CGFloat) + (((components?[1])! * 587.0) as CGFloat) + (((components?[2])! * 114.0)) as CGFloat) / (1000.0 as CGFloat)
        
        if brightness < 0.7{
            return false
            
        }else{
            return true
        }
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }

}

class DescriptionLabel: UILabel {
    override func draw(_ rect: CGRect) {
        let  insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        
    }
}

extension UIView {
    func getPixelColorAtPoint(point:CGPoint, sourceView: UIView) -> String{
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        sourceView.layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
        
        pixel.deallocate(capacity: 4)
        
        
        let rgbaComponents = color.cgColor.components
        var hex = "#"
        
        for index in 0...3 {
            
            let value = UInt8((rgbaComponents?[index])! * 255)
            
            if (index == 3 && value == 255) == false {
                
                hex += String(format:"%0.2X", value)
            }
        }
        
        return hex
        
    }
}
