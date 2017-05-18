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
    
    func createDetectLabel(x: CGFloat, y: CGFloat, color: String, caseNo: Int) {
        
        let widthLabel = self.view.bounds.size.width/4
        
        let colorLabel = DetectLabel(frame: CGRect(x: x, y: y,
                                                   width: widthLabel,
                                                   height: widthLabel*4/5),
                                     color: UIColor(hexString: color),
                                     text: color,
                                     caseNo: caseNo)
        self.view.addSubview(colorLabel)
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
        
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        let widthLabel = self.view.bounds.size.width/4
        
        let marginLeft = width/20
        let marginTop = width/4 + (self.navigationController?.navigationBar.bounds.size.height)!
        let marginRight = width*19/20
        let marginBottom = height - width/4
        let mid = width/2
        
        switch (position.x, position.y) {
        case (0..<marginLeft,0..<marginTop): //case 1: goc tren trai
            print("1: goc tren trai")
            createDetectLabel(x: position.x + widthLabel/5, y: position.y, color: pickedColor, caseNo: 1)
            
        case (marginRight...width,0..<marginTop): //case 2: goc tren phai
            print("2: goc tren phai")
            createDetectLabel(x: position.x - widthLabel*6/5, y: position.y, color: pickedColor, caseNo: 2)
            
        case (0..<marginLeft,marginBottom...height): //case 3: goc duoi trai
            print("3: goc duoi trai")
            createDetectLabel(x: position.x + widthLabel/5, y: position.y - widthLabel, color: pickedColor, caseNo: 3)
            
        case (marginRight...width,marginBottom...height): //case 4: goc duoi phai
            print("4: goc duoi phai")
            createDetectLabel(x: position.x - widthLabel*6/5, y: position.y - widthLabel, color: pickedColor, caseNo: 4)
            
        case (0..<marginLeft,marginTop..<marginBottom): //case 5: le trai
            print("5: le trai")
            createDetectLabel(x: position.x + widthLabel/5, y: position.y - widthLabel/5, color: pickedColor, caseNo: 5)
            
        case (marginRight...width,marginTop..<marginBottom): //case 6: le phai
            print("6: le phai")
            createDetectLabel(x: position.x - widthLabel*6/5, y: position.y - widthLabel/5, color: pickedColor, caseNo: 6)
            
        case (marginLeft..<mid,0..<marginTop): //case 7: le tren trai
            print("7: le tren trai")
            createDetectLabel(x: position.x - widthLabel/5, y: position.y + widthLabel/5, color: pickedColor, caseNo: 7)
            
        case (mid...marginRight,0..<marginTop): //case 8: le tren phai
            print("8: le tren phai")
            createDetectLabel(x: position.x - widthLabel*4/5, y: position.y + widthLabel/5, color: pickedColor, caseNo: 8)
            
        case (mid...marginRight,marginTop...height): //case 9: ben phai
            print("9: ben phai")
            createDetectLabel(x: position.x - widthLabel*4/5, y: position.y - widthLabel, color: pickedColor, caseNo: 9)
            
        case (marginLeft..<mid,marginTop...height): //case 10: ben trai
            print("10: ben trai")
            createDetectLabel(x: position.x - widthLabel/5, y: position.y - widthLabel, color: pickedColor, caseNo: 10)
            
        default:
            print("Should not be here")
        }
        
        
        
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
