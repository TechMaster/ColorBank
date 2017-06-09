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
    var paletteButton = UIButton()
    var infoButton = UIButton()
    var mediaButton = UIButton()
    var yourPaletteButton = UIButton()
    var expanding: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = fusumaBackgroundColor
        self.navigationController?.navigationBar.barTintColor = fusumaBackgroundColor
        
        let screenHeight = self.view.bounds.size.height
        
        let titleColor = UIColor(hexString: "#E0E4CC")
        
        
        paletteButton = createButton(posY: 0, hexString: "#69D2E7", title: "Color Palettes", titleColor: titleColor)
        paletteButton.addTarget(self, action: #selector(pushToColorListView), for: .touchUpInside)
        
        yourPaletteButton = createButton(posY: screenHeight/4, hexString: "#A7DBD8", title: "Your Palettes", titleColor: titleColor)
        yourPaletteButton.addTarget(self, action: #selector(pushToYourPalettesView), for: .touchUpInside)
        
        
        mediaButton = createButton(posY: screenHeight/2, hexString: "#F38630", title: "Create Your Own", titleColor: titleColor)
        mediaButton.addTarget(self, action: #selector(pushToMediaView), for: .touchUpInside)
        
        infoButton = createButton(posY: screenHeight*3/4, hexString: "#FA6900", title: "About Us", titleColor: titleColor)
        infoButton.addTarget(self, action: #selector(pushToInfoView), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: Tạo nút
    func createButton(posY: CGFloat, hexString: String, title: String, titleColor: UIColor) -> UIButton {
        let Button = UIButton()
        Button.frame = CGRect(x: 0, y: posY, width: self.view.bounds.size.width, height: self.view.bounds.size.height/4)
        Button.backgroundColor = UIColor(hexString: hexString)
        Button.setTitle(title, for: .normal)
        Button.setTitleColor(titleColor, for: .normal)
        self.view.addSubview(Button)
        return Button
    }
    
    //MARK: Color List
    func pushToColorListView() {
        
        let newViewController = PalettesTabBar()
        self.navigationController?.pushViewController(newViewController, animated: true)
    
    }
    
    //MARK: Your Palettes
    func pushToYourPalettesView() {
        
        let newViewController = YourPalettesTVC()
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
