//
//  ViewController.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var baseImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        createColorListButton()
        createAlbumButton()
        createCameraButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func createColorListButton() {
        let colorlistButton = UIButton()
        colorlistButton.frame = CGRect(x: self.view.bounds.size.width/4, y: self.view.bounds.size.height/3, width: self.view.bounds.size.width/2, height: 50)
        colorlistButton.setTitle("Color List", for: .normal)
        colorlistButton.setTitleColor(UIColor.white, for: .normal)
        colorlistButton.backgroundColor = UIColor.blue
        colorlistButton.addTarget(self, action: #selector(pushToColorListView), for: .touchUpInside)
        colorlistButton.isUserInteractionEnabled = true
        self.view.addSubview(colorlistButton)
    }
    
    func pushToColorListView() {
        let newViewController = ColorListTVC()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func createAlbumButton() {
        let albumButton = UIButton()
        albumButton.frame = CGRect(x: self.view.bounds.size.width/4, y: self.view.bounds.size.height/2, width: self.view.bounds.size.width/2, height: 50)
        albumButton.setTitle("Go to Album", for: .normal)
        albumButton.setTitleColor(UIColor.white, for: .normal)
        albumButton.backgroundColor = UIColor.cyan
        albumButton.addTarget(self, action: #selector(pushToAlbumView), for: .touchUpInside)
        albumButton.isUserInteractionEnabled = true
        self.view.addSubview(albumButton)
    }
    
    func pushToAlbumView() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func createCameraButton() {
        let cameraButton = UIButton()
        cameraButton.frame = CGRect(x: self.view.bounds.size.width/4, y: self.view.bounds.size.height*2/3, width: self.view.bounds.size.width/2, height: 50)
        cameraButton.setTitle("Go to Camera", for: .normal)
        cameraButton.setTitleColor(UIColor.white, for: .normal)
        cameraButton.backgroundColor = UIColor.purple
        cameraButton.addTarget(self, action: #selector(pushToCameraView), for: .touchUpInside)
        cameraButton.isUserInteractionEnabled = true
        self.view.addSubview(cameraButton)
    }
    
    func pushToCameraView() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
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


