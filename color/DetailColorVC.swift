////
////  ScreenA.swift
////  BootStrapDemo
////
////  Created by Techmaster on 9/6/16.
////  Copyright © 2016 Techmaster Vietnam. All rights reserved.
////
//
//import UIKit
//
//class DetailColorVC: UIViewController {
//    var delegateMain: ColorListTVC!
//    var indexSection:Int!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let color_Bar = (delegateMain.menu[indexSection].menus.first?.title)!
//        let arr:[String] = color_Bar.getArrColor()
//        
//        
//        let frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.width)
//        
//        let chart = PieChart(frame: frame , arrColor: self.getUIColor(arr: arr))
//        self.view.addSubview(chart)
//        self.view.addSubview(drawInfo(arr: arr))
//        
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch : UITouch = (event?.allTouches?.first)!
//        let location = touch.location(in: self.view)
//        let pickedColor = self.view.getPixelColorAtPoint(point: location, sourceView: self.view)
//        
//        print(pickedColor)
//    }
//    
//    
//    func getUIColor(arr: [String])->[UIColor]{
//        var cl : [UIColor] = []
//        for color in arr{
//            cl.append(UIColor(hexString: color))
//        }
//        return cl
//    }
//    
//    func drawInfo(arr: [String])->UIView{
//        let infoView = UIView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
//        let _height = (infoView.frame.height-64)/5
//        for i in 0..<arr.count{
//            let label = UILabel(frame: CGRect(x: 0, y:64+CGFloat(i)*_height, width: infoView.frame.width, height:_height))
//            label.text = arr[i]
//            label.textAlignment = .center
//            label.backgroundColor = UIColor(hexString: arr[i])
//            
//            infoView.addSubview(label)
//        }
//        return infoView
//        
//        
//    }
//}
//
//extension UIView {
//    func getPixelColorAtPoint(point:CGPoint, sourceView: UIView) -> String{
//        
//        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
//        
//        context!.translateBy(x: -point.x, y: -point.y)
//        sourceView.layer.render(in: context!)
//        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
//                                    green: CGFloat(pixel[1])/255.0,
//                                    blue: CGFloat(pixel[2])/255.0,
//                                    alpha: CGFloat(pixel[3])/255.0)
//        
//        pixel.deallocate(capacity: 4)
//        
//        
//        let rgbaComponents = color.cgColor.components
//        var hex = "#"
//        
//        for index in 0...3 {
//            
//            let value = UInt8((rgbaComponents?[index])! * 255)
//            
//            if (index == 3 && value == 255) == false {
//                
//                hex += String(format:"%0.2X", value)
//            }
//        }
//        return hex
//        
//    }
//}
