//
//  ChosenImageVC.swift
//  color
//
//  Created by NhatMinh on 4/28/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import Foundation
import UIKit

class ChosenImageVC: UIViewController{
    
    let imageView = UIImageView()
    var image = UIImage()
    
    var scrollView = UIScrollView()
    var isZoomIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImageView()
    }
    
    
    func createImageView() {
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        let magView = YPMagnifyingView()
        magView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        let magGlass = YPMagnifyingGlass(frame: CGRect(x: magView.frame.origin.x, y: magView.frame.origin.y, width: 55, height: 55))
        magGlass.scale = 2
        magView.magnifyingGlass = magGlass
        
        let focusPoint = YPMagnifyingGlass(frame: CGRect(x: magView.frame.origin.x, y: magView.frame.origin.y, width: 20, height: 20))
        focusPoint.scale = 5
        magView.focusPoint = focusPoint
        
        let sniper = DetectLabel(frame: CGRect(x: magView.frame.origin.x, y: magView.frame.origin.y, width: 30, height: 30))
        magView.sniper = sniper
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg(_:)))
//        tap.numberOfTapsRequired = 1
//        
//        self.imageView.addGestureRecognizer(tap)
        
        self.view.addSubview(magView)
        magView.addSubview(imageView)
        
        
        
        
        
        
    }
    
    func tapImg(_ gesture: UITapGestureRecognizer){
        
        for v in view.subviews{
            if v is UILabel{
                v.removeFromSuperview()
            }
        }
        
        let position = gesture.location(in: self.view)
        
        let pickedColor = self.view.getPixelColorAtPoint(point: position, sourceView: self.view)
        
        print(pickedColor)
        
//        let widthLabel: CGFloat = 30
//        
//        let colorLabel = DetectLabel(frame: CGRect(x: position.x - widthLabel/2,
//                                                   y: position.y - widthLabel/2,
//                                                   width: widthLabel,
//                                                   height: widthLabel))
//        self.view.addSubview(colorLabel)
        
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
