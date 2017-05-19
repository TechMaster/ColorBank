//
//  ScreenA.swift
//  BootStrapDemo
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import Foundation

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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr = colorArr[indexSection].colorArray
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = colorArr[indexSection].colorName
        
        createButton(title: "Share", posX: 5).addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        //        createButton(title: "Rotate", posX: 1).addTarget(self, action: #selector(drawInfo1(arr:)), for: .touchUpInside)
        
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
        
        //        self.view.addSubview(drawInfo1(arr: arr))
        
    }
    
    func getUIColor(arr: [String])->[UIColor]{
        var cl : [UIColor] = []
        for color in arr{
            cl.append(UIColor(hexString: color))
        }
        return cl
    }
    
    // Rút gọn 2 func createShareButton và createRotateButton
    
    func createButton(title: String, posX: CGFloat ) -> UIButton {
        let Button = UIButton()
        Button.tag = 200
        Button.frame = CGRect(x: self.view.bounds.size.width*(posX)/8, y: self.view.bounds.size.height*17/20, width: self.view.bounds.size.width/4, height: self.view.bounds.size.height/10)
        Button.backgroundColor = UIColor.cyan
        Button.setTitle(title, for: .normal)
        
        Button.layer.cornerRadius = 10
        self.view.addSubview(Button)
        return Button
    }
    
    func share(sender: UIButton){
        let activityVC = UIActivityViewController(activityItems: [shareImg], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func creatBtn(index: Int) -> UIButton {
        let btn = UIButton()
        btn.setTitle(arr[index], for: .normal)
        
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
    }
    func drawinfo2() -> UIView {
        label5.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        label5.backgroundColor = UIColor(hexString: arr[4])
        
        let label1 = UILabel(frame: CGRect(x: 200, y: 50, width: 200, height: 20))
        label1.text = "HEX :"
        label1.font = label1.font.withSize(20)
        label1.textColor = UIColor.black
        let label2 = UILabel(frame: CGRect(x: 200, y: 80, width: 200, height: 20))
        label2.text = "RGB :"
        label2.font = label2.font.withSize(20)
        label2.textColor = UIColor.black
        label3.frame = CGRect(x: 270, y: 50, width: 200, height: 20)
        label3.text = arr[4]
        label3.font = label3.font.withSize(20)
        label3.textColor = UIColor.black
        label4 = UILabel(frame: CGRect(x: 270, y: 80, width: 200, height: 20))
        label4.text = rgbColor(color: arr[4])
        label4.font = label4.font.withSize(20)
        label4.textColor = UIColor.black
        infoView2.addSubview(label1)
        infoView2.addSubview(label2)
        infoView2.addSubview(label3)
        infoView2.addSubview(label4)
        infoView2.addSubview(label5)
        
        
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

