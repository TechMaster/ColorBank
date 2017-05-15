//
//  ChosenImageVC.swift
//  color
//
//  Created by NhatMinh on 4/28/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import Foundation
import UIKit

class ChosenImageVC: UIViewController, UIScrollViewDelegate {
    
    let imageView = UIImageView()
    var image = UIImage()
    
    var scrollView = UIScrollView()
    var isZoomIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        createImageView()
        
    }
    
 
    
    func createColorLabel(x: CGFloat, y: CGFloat, color: String) {
        var lineColor = UIColor()
        var textColor = UIColor()
        let bgColor = UIColor(hexString: color)
        
        if bgColor.isLight() == true {
            textColor = UIColor.black
            lineColor = UIColor.black
        }else{
            textColor = UIColor.white
            lineColor = UIColor.white
        }
        let colorLabel = DetectLabel(frame: CGRect.zero, pos: CGPoint(x:x, y:y), lineColor: lineColor, bgColor: bgColor, text: color, textColor: textColor)
        
        self.view.addSubview(colorLabel)
    }
    
    func createImageView() {
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg(_:)))
        tap.numberOfTapsRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg(_:)))
        doubleTap.numberOfTapsRequired = 2
        tap.require(toFail: doubleTap)
        
        self.imageView.addGestureRecognizer(tap)
        self.imageView.addGestureRecognizer(doubleTap)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        scrollView.contentSize = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func tapImg(_ gesture: UITapGestureRecognizer){
        
        for v in view.subviews{
            if v is UILabel{
                v.removeFromSuperview()
            }
        }
        
        let position = gesture.location(in: self.view)
        
        let pickedColor = self.view.getPixelColorAtPoint(point: position, sourceView: self.view)
        
        let margin = self.view.bounds.size.width/4
        
    
        if (position.x < margin && position.y < margin){
            createColorLabel(x: position.x, y: position.y, color: pickedColor)
        
        }else if (position.x < margin && position.y > margin){
            createColorLabel(x: position.x, y: position.y - margin, color: pickedColor)
        
        }else if (position.x > margin && position.y < margin){
            createColorLabel(x: position.x, y: position.y, color: pickedColor)
        
        }else{ 
            createColorLabel(x: position.x - margin, y: position.y - margin, color: pickedColor)
            
        }
        
    }
    
    func doubleTapImg(_ gesture: UITapGestureRecognizer){
        
        for v in view.subviews{
            if v is UILabel{
                v.removeFromSuperview()
            }
        }
        
        let position = gesture.location(in: self.imageView)
        
        if isZoomIn == false {
            zoomRectForScale(scale: scrollView.zoomScale * 1.5, center: position)
            isZoomIn = true
        }else{
            zoomRectForScale(scale: scrollView.zoomScale * 0.5, center: position)
            isZoomIn = false
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint){
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height/scale
        zoomRect.size.width = scrollViewSize.width/scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        scrollView.zoom(to: zoomRect, animated: true)
    }
}

extension UIColor {
    func isLight() -> Bool
    {
        let components = self.cgColor.components
        let brightness = ((((components?[0])! * 299.0) as CGFloat) + (((components?[1])! * 587.0) as CGFloat) + (((components?[2])! * 114.0)) as CGFloat) / (1000.0 as CGFloat)
        
        if brightness < 0.5{
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
