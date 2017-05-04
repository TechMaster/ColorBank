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
