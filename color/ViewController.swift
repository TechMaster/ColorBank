//
//  ViewController.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import Foundation
import Fusuma

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FusumaDelegate {
    
    var baseImage = UIImage()
    var menuButton = UIButton()
    var paletteButton = UIButton()
    var infoButton = UIButton()
    var mediaButton = UIButton()
    var expanding: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = fusumaBackgroundColor
        self.navigationController?.navigationBar.barTintColor = fusumaBackgroundColor
        
        
        let X = self.view.bounds.size.width/2
        let Y = self.view.bounds.size.height/2
        let buttonWidth = self.view.bounds.size.width/7
        
        paletteButton = createButton(image: #imageLiteral(resourceName: "Palette"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        infoButton = createButton(image: #imageLiteral(resourceName: "Info"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        mediaButton = createButton(image: #imageLiteral(resourceName: "Album"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        menuButton = createButton(image: #imageLiteral(resourceName: "Menu"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        
        paletteButton.alpha = 0
        infoButton.alpha = 0
        mediaButton.alpha = 0
        
        menuButton.addTarget(self, action: #selector(animateButtons), for: .touchUpInside)
        paletteButton.addTarget(self, action: #selector(pushToColorListView), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(pushToInfoView), for: .touchUpInside)
        mediaButton.addTarget(self, action: #selector(pushToMediaView), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK:
    func animateButtons() {
        let center = menuButton.center
        let spacing = self.view.bounds.size.width/4
        
        if expanding == false
        {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.paletteButton.center = CGPoint(x: center.x, y: center.y - spacing)
                self.paletteButton.alpha = 1
                
                self.infoButton.center = CGPoint(x: center.x/2, y: center.y)
                self.infoButton.alpha = 1
                
                self.mediaButton.center = CGPoint(x: center.x*3/2, y: center.y)
                self.mediaButton.alpha = 1
            })
            expanding = true
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.paletteButton.center = self.menuButton.center
                self.paletteButton.alpha = 0
                
                self.infoButton.center = self.menuButton.center
                self.infoButton.alpha = 0
                
                self.mediaButton.center = self.menuButton.center
                self.mediaButton.alpha = 0
            })
            expanding = false
        }
    }
    
    //MARK: Tạo nút
    func createButton(image: UIImage,posX: CGFloat, posY: CGFloat) -> UIButton {
        let Button = UIButton()
        Button.frame = CGRect(x: posX, y: posY, width: self.view.bounds.size.width/6, height: self.view.bounds.size.width/6)
        Button.setBackgroundImage(image, for: .normal)
        Button.layer.cornerRadius = Button.frame.width/2
        self.view.addSubview(Button)
        return Button
    }
    
    //MARK: Color List
    func pushToColorListView() {
        let newViewController = ColorListTVC()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    //MARK: Info
    func pushToInfoView() {
        
    }
    
    //MARK: Media
    func pushToMediaView() {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self as FusumaDelegate
        fusuma.hasVideo = false // If you want to let the users allow to use video.
        self.navigationController?.pushViewController(fusuma, animated: true)
        
    }
    
    //MARK:  select image delegate
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        let newViewController = ChosenImageVC()
        newViewController.image = image
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func fusumaWillClosed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
