//
//  ImageCropVC.swift
//  color
//
//  Created by Loc Tran on 5/25/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class ImageCropVC: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    var imagePicked = UIImage()
    var cropAreaView = CropAreaView()
    var isZoomIn = false
    
    var frontScrollViews: [UIScrollView] = []
    

    
    
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
        
        self.createScrollView()
        self.createImageView()
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.image = imagePicked
        self.createCropAreaView()
        self.createChooseButton()
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
        
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight + (screenHeight - screenWidth)/2)
        
        scrollView.contentInset = UIEdgeInsets(top: (screenHeight - screenWidth)/2, left: 0, bottom: 0, right: 0)
        
        
        scrollView.clipsToBounds = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.bounces = true
        scrollView.scrollsToTop = true
        
        scrollView.delegate = self

        self.view.addSubview(scrollView)
    }
    
    func createImageView(){
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTap)
        
        let frontScrollView = UIScrollView(frame: CGRect( x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        frontScrollView.minimumZoomScale = 1
        frontScrollView.maximumZoomScale = 4
        frontScrollView.delegate = self
        frontScrollView.addSubview(imageView)
        frontScrollViews.append(frontScrollView)
        
        self.scrollView.addSubview(frontScrollView)
    }
    
    
    func doubleTapImg(_ gesture: UITapGestureRecognizer){
        
        let position = gesture.location(in: self.imageView)
        
        if isZoomIn == false {
            zoomRectForScale(scale: scrollView.zoomScale * 4, center: position)
            isZoomIn = true
        }else{
            zoomRectForScale(scale: scrollView.zoomScale * 0.25, center: position)
            isZoomIn = false
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint){
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height/scale
        zoomRect.size.width = scrollViewSize.width/scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        frontScrollViews[0].zoom(to: zoomRect, animated: true)
    }

    
    func changeScrollable(_ isScrollable: Bool) {
        
        self.scrollView.isScrollEnabled = isScrollable
    }
    
    
    
    // MARK: UIScrollViewDelegate Protocol
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
            
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        self.scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight + (screenHeight - screenWidth)/2)
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
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
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
    
    //MARK: create crop window
    func createCropAreaView(){
        
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        //Crop window
        cropAreaView.frame = CGRect(x: 0, y: screenHeight/2 - screenWidth/2, width: screenWidth, height: screenWidth)
        cropAreaView.layer.borderWidth = 1
        cropAreaView.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(cropAreaView)
        
        //Dim part
        let upperArea = UIView()
        upperArea.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/2 - screenWidth/2)
        upperArea.backgroundColor = UIColor.black
        upperArea.alpha = 0.7
        self.view.addSubview(upperArea)
        
        let lowerArea = UIView()
        lowerArea.frame = CGRect(x: 0, y: cropAreaView.frame.maxY, width: screenWidth, height: screenHeight/2 - screenWidth/2)
        lowerArea.backgroundColor = UIColor.black
        lowerArea.alpha = 0.7
        self.view.addSubview(lowerArea)
        
        let buttonBar = UIButton()
        buttonBar.frame = CGRect(x: 0, y: screenHeight-lowerArea.bounds.size.height/2, width: screenWidth, height: lowerArea.bounds.size.width/2)
        buttonBar.backgroundColor = UIColor.black
        buttonBar.alpha = 0.5
        self.view.addSubview(buttonBar)
        
    }
    
    //MARK: create button
    func createChooseButton(){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        let chooseButton = UIButton()
        chooseButton.frame = CGRect(x: screenWidth*3/4, y: screenHeight - (screenHeight - cropAreaView.frame.maxY)/2, width: screenWidth/4, height: (screenHeight - cropAreaView.frame.maxY)/2)
        chooseButton.setTitle("Choose", for: .normal)
        chooseButton.setTitleColor(UIColor.white, for: .normal)
        chooseButton.titleLabel?.textAlignment = .center
        chooseButton.addTarget(self, action: #selector(crop), for: .touchUpInside)
        self.view.addSubview(chooseButton)
    }
    
    func createCancelButton(){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: screenHeight - (screenHeight - cropAreaView.frame.maxY)/2, width: screenWidth/4, height: (screenHeight - cropAreaView.frame.maxY)/2)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    
}

//MARK: allow to touch the view behind
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



