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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr = colorArr[indexSection].colorArray
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = colorArr[indexSection].colorName
        
        createButton(title: "Share", posX: 5).addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        createButton(title: "Rotate", posX: 1).addTarget(self, action: #selector(showView1), for: .touchUpInside)
        
        navAndStatusHeight = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        infoView = UIView(frame:  CGRect(x: 0, y: navAndStatusHeight, width: self.view.frame.width, height: self.view.frame.height*(4/5) - navAndStatusHeight))
        
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
    
    
    func showView1(){
        
        for view in self.view.subviews {
            if view.tag != 200{
                view.removeFromSuperview()
            }
        }
        
        let infoViewWidth = infoView.frame.width
        let infoViewHeight = infoView.frame.height
        
        rotateCount += 1
        if rotateCount == 2 {
            self.view.addSubview(drawInfo(arr: arr, width: infoViewWidth/5, height: infoViewHeight))
        }
        if rotateCount == 3 {
            self.view.addSubview(drawInfo(arr: arr, width: infoViewWidth, height: infoViewHeight/5))
        }
        if rotateCount == 4 {
            self.view.addSubview(drawInfo(arr: arr, width: infoViewWidth/5, height: infoViewHeight))
        }
        if rotateCount == 5 {
            self.view.addSubview(drawInfo1(arr: arr))
            rotateCount = 1
        }
        
    }
    
    func drawInfo1(arr: [String])->UIView{
        
        let infoViewHeight = infoView.frame.height/5
        let infoViewWidth = infoView.frame.width
        
        for i in 0..<arr.count{
            
            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(i)*infoViewHeight, width: infoViewWidth, height:infoViewHeight))
            
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
    
    // Rút gọn 3 func drawInfo1 drawInfo2 drawInfo3
    
    func drawInfo(arr: [String], width: CGFloat, height: CGFloat) -> UIView {
        for i in (0..<arr.count).reversed(){
            let label = UILabel()
            switch rotateCount {
            case 2:
                label.frame = CGRect(x: self.view.bounds.size.width - CGFloat(i+1)*width, y: 0, width: width, height: height)
            case 3:
                label.frame = CGRect(x: 0, y: infoView.frame.height - CGFloat(i+1)*height, width: width, height:height)
            case 4:
                label.frame = CGRect(x:CGFloat(i)*width, y: 0, width: width, height:height)
            default:
                break
            }
            
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

