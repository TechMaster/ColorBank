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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr = colorArr[indexSection].colorArray
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = colorArr[indexSection].colorName
        
        creatRotateButton()
        createShareButton()
        
        self.view.addSubview(drawInfo1(arr: arr))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func getUIColor(arr: [String])->[UIColor]{
        var cl : [UIColor] = []
        for color in arr{
            cl.append(UIColor(hexString: color))
        }
        return cl
    }
    
    func createShareButton(){
        let btnShare = UIButton()
        btnShare.tag = 200
        btnShare.frame = CGRect(x: self.view.bounds.size.width*5/8, y: self.view.frame.height*(17/20), width: self.view.frame.width/4, height: self.view.frame.height/10)
        
        btnShare.backgroundColor = UIColor.cyan
        btnShare.setTitle("Share", for: .normal)
        btnShare.layer.cornerRadius = 10
        btnShare.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside )
        self.view.addSubview(btnShare)
    }
    
    func share(sender: UIButton){
        let activityVC = UIActivityViewController(activityItems: [shareImg], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func creatRotateButton() {
        let rotateButton =  UIButton()
        rotateButton.tag = 200
        rotateButton.frame = CGRect(x: self.view.bounds.size.width/8, y: self.view.frame.height*(17/20), width: self.view.frame.width/4, height: self.view.frame.height/10)
        
        rotateButton.backgroundColor = UIColor.cyan
        rotateButton.setTitle("Rotate", for: .normal)
        rotateButton.layer.cornerRadius = 10
        rotateButton.addTarget(self, action: #selector(showView1), for: .touchUpInside)
        rotateButton.isUserInteractionEnabled = true
        
        self.view.addSubview(rotateButton)
        
    }
    
    func showView1(){
        
        for view in self.view.subviews {
            if view.tag != 200{
                view.removeFromSuperview()
            }
        }
        
        rotateCount += 1
        if rotateCount == 2 {
            self.view.addSubview(drawInfo2(arr: arr))
        }
        if rotateCount == 3 {
            self.view.addSubview(drawInfo3(arr: arr))
        }
        if rotateCount == 4 {
            self.view.addSubview(drawInfo4(arr: arr))
        }
        if rotateCount == 5 {
            self.view.addSubview(drawInfo1(arr: arr))
            rotateCount = 1
        }
        
    }
    
    func drawInfo1(arr: [String])->UIView{
        
        let _navAndStatus = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        
        let infoView = UIView(frame: CGRect(x: 0, y: _navAndStatus, width: self.view.frame.width, height: self.view.frame.height*(4/5) - _navAndStatus))
        
        let _height = infoView.frame.height/5
        let _width = infoView.frame.width
        
        for i in 0..<arr.count{
            
            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(i)*_height, width: _width, height:_height))
            
            label.text = arr[i]
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.backgroundColor = UIColor(hexString: arr[i])
            
            if label.backgroundColor?.isLight() == true {
                label.textColor = UIColor.black
            }else{
                label.textColor = UIColor.white
            }
            
            infoView.addSubview(label)
        }
        
        shareImg =  UIImage.init(view: infoView)
        
        return infoView
        
    }
    
    func drawInfo2(arr: [String])->UIView{
        
        let _navAndStatus = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        
        let infoView = UIView(frame:  CGRect(x: 0, y: _navAndStatus, width: self.view.frame.width, height: self.view.frame.height*(4/5) - _navAndStatus))
        
        let _height = infoView.frame.height
        let _width = infoView.frame.width/5
        for i in (0..<arr.count).reversed(){
            
            let label = UILabel(frame: CGRect(x: self.view.bounds.size.width - CGFloat(i+1)*_width, y: 0, width: _width, height:_height))
            label.text = arr[i]
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.backgroundColor = UIColor(hexString: arr[i])
            if label.backgroundColor?.isLight() == true {
                label.textColor = UIColor.black
            }else{
                label.textColor = UIColor.white
            }
            
            infoView.addSubview(label)
        }
        return infoView
        
    }
    
    func drawInfo3(arr: [String])->UIView{
        
        let _navAndStatus = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        
        let infoView = UIView(frame:  CGRect(x: 0, y: _navAndStatus, width: self.view.frame.width, height: self.view.frame.height*(4/5) - _navAndStatus))
        
        let _height = infoView.frame.height/5
        let _width = infoView.frame.width
        
        for i in (0..<arr.count).reversed(){
            
            let label = UILabel(frame: CGRect(x: 0, y: infoView.frame.height - CGFloat(i+1)*_height, width: _width, height:_height))
            
            label.text = arr[i]
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.backgroundColor = UIColor(hexString: arr[i])
            
            if label.backgroundColor?.isLight() == true {
                label.textColor = UIColor.black
            }else{
                label.textColor = UIColor.white
            }
            infoView.addSubview(label)
        }
        return infoView
        
    }
    
    func drawInfo4(arr: [String])->UIView{
        
        let _navAndStatus = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        
        let infoView = UIView(frame:  CGRect(x: 0, y: _navAndStatus, width: self.view.frame.width, height: self.view.frame.height*(4/5) - _navAndStatus))
        
        let _height = infoView.frame.height
        let _width = infoView.frame.width/5
        
        for i in (0..<arr.count).reversed(){
            
            let label = UILabel(frame: CGRect(x:CGFloat(i)*_width, y: 0, width: _width, height:_height))
            
            label.text = arr[i]
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.backgroundColor = UIColor(hexString: arr[i])
            if label.backgroundColor?.isLight() == true {
                label.textColor = UIColor.black
            }else{
                label.textColor = UIColor.white
            }
            
            infoView.addSubview(label)
        }
        return infoView
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

