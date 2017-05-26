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
    var button1 = UIButton()
    let container = UIView()
    let frontView = UIView()
    let backView = UIView()
    var lastBtnIndex = 0
    var intro = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        arr = colorArr[indexSection].colorArray
        
        self.navigationItem.title = colorArr[indexSection].colorName
        
        navAndStatusHeight = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        
        
        
        creatBtn(index: 0).addTarget(self, action: #selector(animate), for: .touchUpInside)
        creatBtn(index: 1).addTarget(self, action: #selector(animate), for: .touchUpInside)
        creatBtn(index: 2).addTarget(self, action: #selector(animate), for: .touchUpInside)
        creatBtn(index: 3).addTarget(self, action: #selector(animate), for: .touchUpInside)
        creatBtn(index: 4).addTarget(self, action: #selector(animate), for: .touchUpInside)
        
        createAnimateView()
    }
    
    func createAnimateView() {
        container.frame = CGRect(x: 0, y: self.view.bounds.size.height/2, width: self.view.bounds.size.width, height: self.view.bounds.size.height/2)
        self.view.addSubview(container)
        
        self.frontView.frame = CGRect(x: 0, y: 0, width: container.bounds.size.width, height: container.bounds.size.height)
        self.frontView.backgroundColor = UIColor(hexString: arr[0])
        self.frontView.addSubview(createCodeLabel(index: 0))
        self.frontView.layer.borderColor = UIColor.white.cgColor
        self.frontView.layer.borderWidth = 2
        self.backView.frame = frontView.frame
        
        self.container.addSubview(frontView)
    }
    
    func creatBtn(index: Int) -> UIButton{
        let btn = UIButton()
        let screenWidth = self.view.bounds.size.width
        btn.tag = 300 + index
        btn.frame = CGRect(x:CGFloat(index)*(screenWidth/5), y: navAndStatusHeight, width: screenWidth/5, height: self.view.bounds.size.height/2 - navAndStatusHeight + 2)
        btn.backgroundColor = UIColor(hexString: arr[index])
        if intro == true && index == 0 {
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor.white.cgColor
            intro = false
        }
        self.view.addSubview(btn)
        return btn
    }
    func animate(sender: UIButton) {
        // create a 'tuple' (a pair or more of objects assigned to a single variable)
        var views : (frontView: UIView, backView: UIView)
        if sender.tag - 300 != lastBtnIndex {
            creatBtn(index: lastBtnIndex).addTarget(self, action: #selector(animate), for: .touchUpInside)
        }
        createAnimateView()
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.white.cgColor
        if self.frontView.superview != nil{
            self.backView.backgroundColor = sender.backgroundColor
            self.backView.layer.borderColor = UIColor.white.cgColor
            self.backView.layer.borderWidth = 2
            deleteHexAndRgbLabel(view: backView)
            self.backView.addSubview(createCodeLabel(index: (sender.tag - 300)))
            views = (frontView: self.frontView, backView: self.backView)
        }
        else
        {
            self.frontView.backgroundColor = sender.backgroundColor
            self.frontView.layer.borderColor = UIColor.white.cgColor
            self.frontView.layer.borderWidth = 2
            deleteHexAndRgbLabel(view: frontView)
            self.frontView.addSubview(createCodeLabel(index: (sender.tag - 300)))
            views = (frontView: self.backView, backView: self.frontView)
        }
        
        // set a transition style
        let transitionOptions = UIViewAnimationOptions.transitionCurlUp
        
        // with no animation block, and a completion block set to 'nil' this makes a single line of code
        if sender.tag - 300 != lastBtnIndex {
            UIView.transition(from: views.frontView, to: views.backView, duration: 1.0, options: transitionOptions, completion: nil)
        }
        lastBtnIndex = sender.tag - 300
    }
    
    func createCodeLabel(index: Int) -> UILabel {
        let label = SRCopyableLabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height/2))
        label.numberOfLines = 4
        label.baselineAdjustment = .alignCenters
        label.text = "Hex : \(arr[index])\n\nRGB : \(rgbColor(color: arr[index]))"
        if UIColor(hexString: arr[index]).isLight() == true
        {
            label.textColor = UIColor.black
        }
        else
        {
            label.textColor = UIColor.white
        }
        label.textAlignment = .center
        label.font = UIFont(name: "American Typewriter", size: 25)
        label.adjustsFontSizeToFitWidth = true
        self.view.addSubview(label)
        return label
    }
    
    func getUIColor(arr: [String])->[UIColor]{
        var cl : [UIColor] = []
        for color in arr{
            cl.append(UIColor(hexString: color))
        }
        return cl
    }
    
    func deleteHexAndRgbLabel(view: UIView) {
        for v in view.subviews
        {
            v.removeFromSuperview()
        }
    }
    
    func share(sender: UIButton){
        let activityVC = UIActivityViewController(activityItems: [shareImg], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
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

