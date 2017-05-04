//
//  ChosenImageVC.swift
//  color
//
//  Created by NhatMinh on 4/28/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class ChosenImageVC: UIViewController {
    
    var magView = YPMagnifyingView()
    let imageView = UIImageView()
    var image = UIImage()
    var pickedColor = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImageView()
        
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        for v in view.subviews{
    //            if v is UILabel{
    //                v.removeFromSuperview()
    //            }
    //        }
    //
    //        let touch: UITouch = (event?.allTouches?.first)!
    //        let location = touch.location(in: self.magView)
    //        if location.y <= (self.navigationController?.navigationBar.bounds.size.height)!{
    //            self.navigationController?.setNavigationBarHidden(false, animated: true)
    //
    //        }else {
    //
    //            self.navigationController?.setNavigationBarHidden(true, animated: true)
    //            pickedColor = self.magView.getPixelColorAtPoint(point: location, sourceView: self.magView)
    //
    //            if (location.x < self.view.bounds.size.width/4){
    //                createColorLabel(x: location.x, y: location.y - self.view.bounds.size.width/4)
    //            }else{
    //                createColorLabel(x: location.x - self.view.bounds.size.width/4, y: location.y - self.view.bounds.size.width/4)
    //            }
    //
    //        }
    //    }
    
//    func createColorLabel(x: CGFloat, y: CGFloat, color: String) {
//        
//        let colorLabel = UILabel()
//        colorLabel.frame = CGRect(x: x,
//                                  y: y,
//                                  width: self.view.bounds.size.width/4,
//                                  height: self.view.bounds.size.width/4)
//        
//        colorLabel.text = color
//        colorLabel.backgroundColor = UIColor(hexString: color)
//        colorLabel.textAlignment = .center
//        colorLabel.layer.borderWidth = 2
//        colorLabel.layer.masksToBounds = true
//        
//        if colorLabel.backgroundColor?.isLight() == true {
//            colorLabel.textColor = UIColor.black
//            colorLabel.layer.borderColor = UIColor.black.cgColor
//        }else{
//            colorLabel.textColor = UIColor.white
//            colorLabel.layer.borderColor = UIColor.white.cgColor
//        }
//        
//        self.magView.addSubview(colorLabel)
//    }
    
    func createImageView() {
        
        magView = YPMagnifyingView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        
        self.view.addSubview(magView)
        
        let mag = YPMagnifyingGlass(frame:CGRect(x: magView.frame.origin.x,
                                                 y: magView.frame.origin.y,
                                                 width: 100,
                                                 height: 100))
        mag.scale = 2
        magView.magnifyingGlass = mag
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        magView.addSubview(imageView)
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
