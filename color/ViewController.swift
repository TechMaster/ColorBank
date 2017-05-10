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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        let viewHeight = self.view.bounds.size.height
        createButton(title: "Palettes", posY: viewHeight/3 , color: UIColor(hexString: "3546C2")).addTarget(self, action: #selector(pushToColorListView), for: .touchUpInside)
        createButton(title: "Album", posY: viewHeight/2 , color: UIColor(hexString: "7340FF")).addTarget(self, action: #selector(pushToAlbumView), for: .touchUpInside)
        createButton(title: "Camera", posY: viewHeight*2/3 , color: UIColor(hexString: "5D22C5")).addTarget(self, action: #selector(pushToCameraView), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    //MARK: Tạo nút
    func createButton(title: String, posY: CGFloat, color: UIColor) -> UIButton {
        let Button = UIButton()
        Button.frame = CGRect(x: self.view.bounds.size.width/4, y: posY, width: self.view.bounds.size.width/2, height: 50)
        Button.setTitle(title, for: .normal)
        Button.setTitleColor(UIColor.white, for: .normal)
        Button.backgroundColor = color
        Button.layer.cornerRadius = 8
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    //MARK:  image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            baseImage = pickedImage
        }
        
        let newViewController = ChosenImageVC()
        newViewController.image = baseImage
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


