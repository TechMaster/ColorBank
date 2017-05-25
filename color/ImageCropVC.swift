//
//  ImageCropVC.swift
//  color
//
//  Created by Loc Tran on 5/25/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class ImageCropVC: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate {
    
    
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    
    
    
    var imagePicked = UIImage()
    
    var cropAreaView = CropAreaView()
    
    var cropArea:CGRect{
        get{
            let factor = imageView.image!.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let imageFrame = imageView.imageFrame()
            let x = (scrollView.contentOffset.x + cropAreaView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + cropAreaView.frame.origin.y - imageFrame.origin.y) * scale * factor
            let width = cropAreaView.frame.size.width * scale * factor
            let height = cropAreaView.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createScrollView()
        createImageView()
        
        self.imageView.image = imagePicked
        self.createCropAreaView()
        self.createCropButton()
        self.createCancelButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    func createScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height*1.5)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        self.view.addSubview(scrollView)
    }
    
    func createImageView(){
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        imageView.contentMode = .scaleAspectFit
        
        self.scrollView.addSubview(imageView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func createCropAreaView(){
        
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        cropAreaView.frame = CGRect(x: 0, y: screenHeight/4, width: screenWidth, height: screenWidth)
        cropAreaView.backgroundColor = UIColor.blue
        cropAreaView.alpha = 0.3
        
        self.view.addSubview(cropAreaView)
    }
    
    func crop(){
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: cropArea)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        let newViewController = ChosenImageVC()
        newViewController.image = croppedImage
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
        
        scrollView.zoomScale = 1
    }
    
    func cancel(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK:  image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
        }
        
        let newViewController = ImageCropVC()
        newViewController.imagePicked = imageView.image!
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        let viewController = ViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func createCropButton(){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        let cropButton = UIButton()
        cropButton.frame = CGRect(x: screenWidth - 40, y: screenHeight - 40, width: 40, height: 40)
        cropButton.backgroundColor = UIColor.red
        cropButton.addTarget(self, action: #selector(crop), for: .touchUpInside)
        self.view.addSubview(cropButton)
    }
    
    func createCancelButton(){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: screenHeight - 40, width: 40, height: 40)
        cancelButton.backgroundColor = UIColor.blue
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    
}

class CropAreaView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}

extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}



