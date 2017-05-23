//
//  ScreenA.swift
//  BootStrapDemo
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class DetailColorVC: UIViewController {
    
    var colorArr: [ColorItem]!
    var indexSection: Int!
    var rotateCount: Int = 1
    var arr = [String]()
    var shareImg = UIImage()
    var navAndStatusHeight: CGFloat!
    var infoView : UIView! = nil
    var infoView2 : UIView! = nil
    var button1 = UIButton()
    var label5 = UILabel()
    var label4 = UILabel()
    var label3 = UILabel()
    var label6 = UILabel()
    var label7 = UILabel()
    var label8 = UILabel()
    var label9 = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr = colorArr[indexSection].colorArray
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = colorArr[indexSection].colorName
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cea))
        navAndStatusHeight = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        infoView = UIView(frame:  CGRect(x: 0, y: navAndStatusHeight, width: self.view.frame.width, height: self.view.frame.height*(1/2) - navAndStatusHeight))
        infoView2 = UIView(frame:  CGRect(x: 0, y: self.view.frame.height*(1/2), width: self.view.frame.width, height: self.view.frame.height*(1/2)))
        //        infoView2.backgroundColor = UIColor.red
        
        self.view.addSubview(infoView)
        
        creatBtn(index: 0).addTarget(self, action: #selector(Colorbtn), for: .touchUpInside)
        creatBtn(index: 1).addTarget(self, action: #selector(Colorbtn), for: .touchUpInside)
        creatBtn(index: 2).addTarget(self, action: #selector(Colorbtn), for: .touchUpInside)
        creatBtn(index: 3).addTarget(self, action: #selector(Colorbtn), for: .touchUpInside)
        creatBtn(index: 4).addTarget(self, action: #selector(Colorbtn), for: .touchUpInside)
        self.view.addSubview(drawinfo2())
        self.view.addSubview(drawinfo3())
    }
    
    func getUIColor(arr: [String])->[UIColor]{
        var cl : [UIColor] = []
        for color in arr{
            cl.append(UIColor(hexString: color))
        }
        return cl
    }
    
    // Rút gọn 2 func createShareButton và createRotateButton
    
    //    func createButton(title: String, posX: CGFloat ) -> UIButton {
    //        let Button = UIButton()
    //        Button.tag = 200
    //
    //        Button.frame = CGRect(x: self.view.bounds.size.width*(posX)/8, y: self.view.bounds.size.height*17/20, width: self.view.bounds.size.width/4, height: self.view.bounds.size.height/10)
    //        Button.backgroundColor = UIColor.cyan
    //        Button.setTitle(title, for: .normal)
    //
    //        Button.layer.cornerRadius = 10
    //        self.view.addSubview(Button)
    //        return Button
    //    }
    func cea() {
        print("xxx")
    }
    func share(sender: UIButton){
        let activityVC = UIActivityViewController(activityItems: [shareImg], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func creatBtn(index: Int) -> UIButton {
        let btn = UIButton()
        btn.setTitle(arr[index], for: .normal)
        btn.tag = 300 + index
        let infoViewHeight = infoView.frame.height
        let infoViewWidth = infoView.frame.width/5
        btn.frame = CGRect(x:CGFloat(index)*infoViewWidth, y: 0, width: infoViewWidth, height: infoViewHeight)
        btn.backgroundColor = UIColor(hexString: arr[index])
        self.infoView.addSubview(btn)
        return btn
    }
    func Colorbtn(sender: UIButton){
        label5.backgroundColor = sender.backgroundColor
        label3.text = sender.titleLabel?.text
        
        label4.text = rgbColor(color: (sender.titleLabel?.text)!)
        
        switch (sender.tag - 300) {
        case 0:
            label6.backgroundColor = UIColor(hexString: arr[1])
            label7.backgroundColor = UIColor(hexString: arr[2])
            label8.backgroundColor = UIColor(hexString: arr[3])
            label9.backgroundColor = UIColor(hexString: arr[4])
        case 1:
            label6.backgroundColor = UIColor(hexString: arr[0])
            label7.backgroundColor = UIColor(hexString: arr[2])
            label8.backgroundColor = UIColor(hexString: arr[4])
            label9.backgroundColor = UIColor(hexString: arr[3])
        case 2:
            label6.backgroundColor = UIColor(hexString: arr[0])
            label7.backgroundColor = UIColor(hexString: arr[1])
            label8.backgroundColor = UIColor(hexString: arr[3])
            label9.backgroundColor = UIColor(hexString: arr[4])
        case 3:
            label6.backgroundColor = UIColor(hexString: arr[1])
            label7.backgroundColor = UIColor(hexString: arr[0])
            label8.backgroundColor = UIColor(hexString: arr[4])
            label9.backgroundColor = UIColor(hexString: arr[2])
        case 4:
            label6.backgroundColor = UIColor(hexString: arr[1])
            label7.backgroundColor = UIColor(hexString: arr[0])
            label8.backgroundColor = UIColor(hexString: arr[2])
            label9.backgroundColor = UIColor(hexString: arr[3])
        default:
            print("xxx")
        }
    }
    func drawinfo2() -> UIView {
        
        
        let label1 = UILabel(frame: CGRect(x: 160, y: 125, width: 200, height: 20))
        label1.text = "HEX :"
        label1.font = label1.font.withSize(20)
        label1.textColor = UIColor.black
        let label2 = UILabel(frame: CGRect(x: 160, y: 170, width: 200, height: 20))
        label2.text = "RGB :"
        label2.font = label2.font.withSize(20)
        label2.textColor = UIColor.black
        label3.frame = CGRect(x: 220, y: 125, width: 180, height: 20)
        label3.text = arr[2]
        label3.font = UIFont(name: "Arial", size: 20)
        label3.textColor = UIColor.black
        label4 = UILabel(frame: CGRect(x: 220, y: 170, width: 180, height: 20))
        label4.text = rgbColor(color: arr[2])
        label3.font = UIFont(name: "Arial", size: 20)
        label4.textColor = UIColor.black
        infoView2.addSubview(label1)
        infoView2.addSubview(label2)
        infoView2.addSubview(label3)
        infoView2.addSubview(label4)
        return infoView2
    }
    
    func drawinfo3()->UIView{
        label5.frame = CGRect(x: 20, y: 120, width: 100, height: 100)
        label5.backgroundColor = UIColor(hexString: arr[2])
        label5.layer.masksToBounds = true
        label5.layer.cornerRadius = 50
        label6.frame = CGRect(x: 85, y: 60, width: 50, height: 50)
        label6.backgroundColor = UIColor(hexString: arr[1])
        label6.layer.masksToBounds = true
        label6.layer.cornerRadius = 25
        
        label7.frame = CGRect(x: 150, y: 18, width: 50, height: 50)
        label7.backgroundColor = UIColor(hexString: arr[0])
        label7.layer.masksToBounds = true
        label7.layer.cornerRadius = 25
        label8.frame = CGRect(x: 85, y: 230, width: 50, height: 50)
        label8.backgroundColor = UIColor(hexString: arr[3])
        label8.layer.masksToBounds = true
        label8.layer.cornerRadius = 25
        label9.frame = CGRect(x: 150, y: 275, width: 50, height: 50)
        label9.backgroundColor = UIColor(hexString: arr[4])
        label9.layer.masksToBounds = true
        label9.layer.cornerRadius = 25
        infoView2.addSubview(label5)
        infoView2.addSubview(label6)
        infoView2.addSubview(label7)
        infoView2.addSubview(label8)
        infoView2.addSubview(label9)
        return infoView2
    }
    func rgbColor(color: String)->String{
        let red = Int((UIColor(hexString: color).cgColor.components?[0])! * 255)
        let green = Int((UIColor(hexString: color).cgColor.components?[1])! * 255)
        let blue = Int((UIColor(hexString: color).cgColor.components?[2])! * 255)
        
        let rgbColor = "\(red).\(green).\(blue)"
        
        return rgbColor
    }
    
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

