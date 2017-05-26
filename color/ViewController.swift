//
//  ViewController.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var baseImage = UIImage()
    var menuButton = UIButton()
    var paletteButton = UIButton()
    var albumButton = UIButton()
    var cameraButton = UIButton()
    var expanding: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let X = self.view.bounds.size.width/2
        let Y = self.view.bounds.size.height/2
        let buttonWidth = self.view.bounds.size.width/7
        
        paletteButton = createButton(image: #imageLiteral(resourceName: "Palette"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        albumButton = createButton(image: #imageLiteral(resourceName: "Album"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        cameraButton = createButton(image: #imageLiteral(resourceName: "Camera"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        menuButton = createButton(image: #imageLiteral(resourceName: "Menu"), posX: X - buttonWidth/2, posY: Y - buttonWidth/2)
        
        paletteButton.alpha = 0
        albumButton.alpha = 0
        cameraButton.alpha = 0
        
        menuButton.addTarget(self, action: #selector(animateButtons), for: .touchUpInside)
        paletteButton.addTarget(self, action: #selector(pushToColorListView), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(pushToAlbumView), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(pushToCameraView), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
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
                
                self.albumButton.center = CGPoint(x: center.x/2, y: center.y)
                self.albumButton.alpha = 1
                
                self.cameraButton.center = CGPoint(x: center.x*3/2, y: center.y)
                self.cameraButton.alpha = 1
            })
            expanding = true
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.paletteButton.center = self.menuButton.center
                self.paletteButton.alpha = 0
                
                self.albumButton.center = self.menuButton.center
                self.albumButton.alpha = 0
                
                self.cameraButton.center = self.menuButton.center
                self.cameraButton.alpha = 0
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
    
    //MARK: Album
    func pushToAlbumView() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: Camera
    func pushToCameraView() {
        
        let newViewController = CameraVC()
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK:  image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            baseImage = pickedImage
        }
        
        let newViewController = ImageCropVC()
        newViewController.imagePicked = baseImage
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
