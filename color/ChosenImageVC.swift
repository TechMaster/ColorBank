//
//  ChosenImageVC.swift
//  color
//
//  Created by NhatMinh on 4/28/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class ChosenImageVC: UIViewController {
    let imageView = UIImageView()
    var image = UIImage()
    var pickedColor = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        createImageView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for v in view.subviews{
            if v is UILabel{
                v.removeFromSuperview()
            }
        }
        let touch: UITouch = (event?.allTouches?.first)!
        let location = touch.location(in: self.view)
        pickedColor = self.view.getPixelColorAtPoint(point: location, sourceView: self.view)
        createColorLabel()
        print(pickedColor)
    }
    
    func createColorLabel() {
        let colorLabel = UILabel()
        colorLabel.frame = CGRect(x: 0, y: self.view.bounds.size.height/2, width: self.view.bounds.size.width, height: 50)
        colorLabel.text = pickedColor
        colorLabel.backgroundColor = UIColor(hexString: pickedColor)
        colorLabel.textAlignment = .center
        colorLabel.textColor = UIColor.black
        self.view.addSubview(colorLabel)
    }
    
    func createImageView() {
        imageView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.size.height)!, width: self.view.bounds.size.width, height: self.view.bounds.size.height - (self.navigationController?.navigationBar.bounds.size.height)!)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
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
