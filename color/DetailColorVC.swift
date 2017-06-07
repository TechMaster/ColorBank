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
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#F38181")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hexString: "#F38181")]
        
        arr = colorArr[indexSection].colorArray
        
        self.navigationItem.title = colorArr[indexSection].colorName
        
        navAndStatusHeight = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        
        
        for i in 0..<5
        {
            creatBtn(index: i).addTarget(self, action: #selector(animate), for: .touchUpInside)
        }
        
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = shareButton
        
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
        var views : (frontView: UIView, backView: UIView)
        if sender.tag - 300 != lastBtnIndex {
            creatBtn(index: lastBtnIndex).addTarget(self, action: #selector(animate), for: .touchUpInside)
            createAnimateView()
        }
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
    
    func createShareView(){
        let shareView = UIView()
        shareView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.width)
        
        let nameLabel = TextLabel()
        nameLabel.frame = CGRect(x: 0, y: 0, width: shareView.bounds.size.width, height: shareView.bounds.size.width/6)
        nameLabel.text = colorArr[indexSection].colorName
        shareView.addSubview(nameLabel)
        
        for i in 0..<5
        {
            let colorLabel = UILabel()
            colorLabel.frame = CGRect(x:CGFloat(i)*(shareView.bounds.size.width/5),
                                      y: nameLabel.frame.maxY,
                                      width: shareView.bounds.size.width/5,
                                      height: shareView.bounds.size.width*2/3)
            colorLabel.backgroundColor = UIColor(hexString: arr[i])
            colorLabel.layer.borderWidth = 1
            colorLabel.layer.borderColor = UIColor.white.cgColor
            colorLabel.layer.masksToBounds = true
            
            let hexLabel = TextLabel()
            hexLabel.frame = CGRect(x:CGFloat(i)*(shareView.bounds.size.width/5),
                                      y: shareView.bounds.size.width*5/6,
                                      width: shareView.bounds.size.width/5,
                                      height: shareView.bounds.size.width/6)
            hexLabel.text = arr[i]
            
            shareView.addSubview(colorLabel)
            shareView.addSubview(hexLabel)
        }
        
        shareImg = UIImage(view: shareView)
        
    }

    func share(){
        createShareView()
        
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

class TextLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.backgroundColor = UIColor.black
        self.textColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let  insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        
    }
}
