//
//  CameraVC.swift
//  color
//
//  Created by NhatMinh on 5/22/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import Photos

class CameraVC: UIViewController, UIGestureRecognizerDelegate {
    
    var fusumaTintIcons : Bool = true
    var fusumaTintColor = UIColor(hexString: "F38181")
    var fusumaBaseTintColor = UIColor(hexString: "#FFFFFF")
    
    var fusumaFlashOnImage : UIImage? = nil
    var fusumaFlashOffImage : UIImage? = nil
    var fusumaFlashAutoImage : UIImage? = nil
    var fusumaFlipImage : UIImage? = nil
    var fusumaShotImage : UIImage? = nil
    
    let previewViewContainer = UIView()
    let shotButton = UIButton()
    let flashButton = UIButton()
    let flipButton = UIButton()
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    var imageOutput: AVCaptureStillImageOutput?
    var focusView: UIView?
    
    var flashOffImage: UIImage?
    var flashOnImage: UIImage?
    var flashAutoImage: UIImage?

    var motionManager: CMMotionManager?
    var currentDeviceOrientation: UIDeviceOrientation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        createPreviewViewContainer()
        createShotButton()
        createFlashButton()
        createFlipButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCamera()
    }
    
    func initialize() {
        
        if session != nil { return }
        
        let bundle = Bundle(for: self.classForCoder)
        
        flashOnImage = fusumaFlashOnImage != nil ? fusumaFlashOnImage : UIImage(named: "ic_flash_on", in: bundle, compatibleWith: nil)
        flashOffImage = fusumaFlashOffImage != nil ? fusumaFlashOffImage : UIImage(named: "ic_flash_off", in: bundle, compatibleWith: nil)
        flashAutoImage = fusumaFlashAutoImage != nil ? fusumaFlashAutoImage : UIImage(named: "ic_flash_auto", in: bundle, compatibleWith: nil)
        let flipImage = fusumaFlipImage != nil ? fusumaFlipImage : UIImage(named: "ic_loop", in: bundle, compatibleWith: nil)
        let shotImage = fusumaShotImage != nil ? fusumaShotImage : UIImage(named: "ic_radio_button_checked", in: bundle, compatibleWith: nil)
        
        if(fusumaTintIcons) {
            flashButton.tintColor = fusumaBaseTintColor
            flipButton.tintColor  = fusumaBaseTintColor
            shotButton.tintColor  = UIColor.black
            
            flashButton.setImage(flashOffImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            flipButton.setImage(flipImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            shotButton.setImage(shotImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        } else {
            flashButton.setImage(flashOffImage, for: UIControlState())
            flipButton.setImage(flipImage, for: UIControlState())
            shotButton.setImage(shotImage, for: UIControlState())

        }
        

        
        self.view.isHidden = false
        
        // AVCapture
        session = AVCaptureSession()
        
        for device in AVCaptureDevice.devices() {
            
            if let device = device as? AVCaptureDevice , device.position == AVCaptureDevicePosition.back {
                
                self.device = device
                
                if !device.hasFlash {
                    
                    flashButton.isHidden = true
                }
            }
        }
        
        do {
            
            if let session = session {
                
                videoInput = try AVCaptureDeviceInput(device: device)
                session.addInput(videoInput)
                imageOutput = AVCaptureStillImageOutput()
                session.addOutput(imageOutput)
                
                let videoLayer = AVCaptureVideoPreviewLayer(session: session)
                videoLayer?.frame = self.previewViewContainer.bounds
                videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                self.previewViewContainer.layer.addSublayer(videoLayer!)
                session.sessionPreset = AVCaptureSessionPresetPhoto
                
                session.startRunning()
                
            }
            
            // Focus View
            self.focusView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
            let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(CameraVC.focus(_:)))
            tapRecognizer.delegate = self
            self.previewViewContainer.addGestureRecognizer(tapRecognizer)
            
        } catch {
            
        }
        flashConfiguration()
        
        self.startCamera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraVC.willEnterForegroundNotification(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func willEnterForegroundNotification(_ notification: Notification) {
        
        startCamera()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func startCamera() {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            
            session?.startRunning()
            
            motionManager = CMMotionManager()
            motionManager!.accelerometerUpdateInterval = 0.2
            motionManager!.startAccelerometerUpdates(to: OperationQueue()) { [unowned self] (data, _) in
                if let data = data {
                    if abs( data.acceleration.y ) < abs( data.acceleration.x ) {
                        if data.acceleration.x > 0 {
                            self.currentDeviceOrientation = .landscapeRight
                        } else {
                            self.currentDeviceOrientation = .landscapeLeft
                        }
                    } else {
                        if data.acceleration.y > 0 {
                            self.currentDeviceOrientation = .portraitUpsideDown
                        } else {
                            self.currentDeviceOrientation = .portrait
                        }
                    }
                }
            }
            
        } else if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted {
            
            stopCamera()
        }
    }
    
    func stopCamera() {
        session?.stopRunning()
        motionManager?.stopAccelerometerUpdates()
        currentDeviceOrientation = nil
    }
    
    func pushToChosenImageVC(image: UIImage) {
        
        let newViewController = ChosenImageVC()
        newViewController.image = image
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func shotButtonPressed() {
        
        guard let imageOutput = imageOutput else {
            
            return
        }
        
        DispatchQueue.global(qos: .default).async(execute: { () -> Void in
            
            let videoConnection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
            videoConnection?.videoOrientation = .portrait
            
            imageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (buffer, error) -> Void in
                
                self.stopCamera()
                
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                
                if let image = UIImage(data: data!) {
                    
                    // Image size
                    let iw: CGFloat = image.size.width
                    let ih: CGFloat = image.size.height
                    
                    // Frame size
                    let sw = self.previewViewContainer.frame.width
                    
                    // The center coordinate along Y axis
                    let rcy = ih * 0.5
                    
                    let imageRef = image.cgImage?.cropping(to: CGRect(x: rcy-iw*0.5, y: 0 , width: iw, height: iw))
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        let resizedImage = UIImage(cgImage: imageRef!, scale: sw/iw, orientation: image.imageOrientation)
                        
                        self.pushToChosenImageVC(image: resizedImage)
                        
                        self.session = nil
                        self.device = nil
                        self.imageOutput = nil
                        self.motionManager = nil
                    })
                }
            })
        })
    }
    
    func flipButtonPressed() {
        
        if !cameraIsAvailable() { return }
        
        session?.stopRunning()
        
        do {
            
            session?.beginConfiguration()
            
            if let session = session {
                for input in session.inputs {
                    session.removeInput(input as! AVCaptureInput)
                }
                
                let position = (videoInput?.device.position == AVCaptureDevicePosition.front) ? AVCaptureDevicePosition.back : AVCaptureDevicePosition.front
                
                for device in AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
                    
                    if let device = device as? AVCaptureDevice , device.position == position {
                        
                        videoInput = try AVCaptureDeviceInput(device: device)
                        session.addInput(videoInput)
                        
                    }
                }
            }
            
            session?.commitConfiguration()
            
        } catch {
            
        }
        
        session?.startRunning()
    }
    
    func flashButtonPressed() {
        
        if !cameraIsAvailable() { return }
        
        do {
            
            if let device = device {
                
                guard device.hasFlash else { return }
                try device.lockForConfiguration()
                let mode = device.flashMode
                if mode == AVCaptureFlashMode.off {
                    
                    device.flashMode = AVCaptureFlashMode.on
                    flashButton.setImage(flashOnImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                    
                } else if mode == AVCaptureFlashMode.on {
                    
                    device.flashMode = AVCaptureFlashMode.auto
                    flashButton.setImage(flashAutoImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                } else if mode == AVCaptureFlashMode.auto{
                    
                    device.flashMode = AVCaptureFlashMode.off
                    flashButton.setImage(flashOffImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                }
                
                device.unlockForConfiguration()
                
            }
            
        } catch _ {
            
            flashButton.setImage(flashOffImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            return
        }
        
    }
    
    func createPreviewViewContainer() {
        let navHeight = self.navigationController?.navigationBar.bounds.size.height
        let screenWidth = self.view.bounds.size.width
        let statusHeight = UIApplication.shared.statusBarFrame.height
        previewViewContainer.frame = CGRect(x: 10, y: navHeight! + statusHeight + 10, width: screenWidth - 20, height: screenWidth - 20)
        
        previewViewContainer.layer.cornerRadius = 8
        previewViewContainer.layer.masksToBounds = true
        
        self.view.addSubview(previewViewContainer)
    }
    
    func createShotButton() {
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        let heightSpaceLeft = screenHeight - previewViewContainer.frame.maxY
        let buttonWidth = heightSpaceLeft/2
        
        shotButton.frame = CGRect(x: screenWidth/2 - buttonWidth/2,
                                  y: (screenHeight-previewViewContainer.frame.maxY)/2 - buttonWidth/2 + previewViewContainer.frame.maxY,
                                  width: buttonWidth,
                                  height: buttonWidth)
        shotButton.addTarget(self, action: #selector(shotButtonPressed), for: .touchUpInside)
        shotButton.backgroundColor = UIColor.clear
        shotButton.layer.cornerRadius = buttonWidth/2
        shotButton.layer.borderWidth = 5
        shotButton.layer.borderColor = UIColor.black.cgColor
        shotButton.layer.masksToBounds = true
        self.view.addSubview(shotButton)
    }
    
    func createFlashButton(){
        let screenWidth = self.view.bounds.size.width
        let buttonWidth = screenWidth/13
        
        flashButton.frame = CGRect(x: previewViewContainer.frame.maxX-buttonWidth-2,
                                   y: previewViewContainer.frame.maxY-buttonWidth*3-2,
                                   width: buttonWidth, height: buttonWidth)
        
        flashButton.backgroundColor = UIColor.clear
        flashButton.layer.cornerRadius = buttonWidth/2
        flashButton.layer.borderWidth = 2
        flashButton.layer.borderColor = UIColor.white.cgColor
        flashButton.layer.masksToBounds = true
        flashButton.addTarget(self, action: #selector(flashButtonPressed), for: .touchUpInside)
        self.view.addSubview(flashButton)
        
    }
    
    func createFlipButton(){
        let screenWidth = self.view.bounds.size.width
        let buttonWidth = screenWidth/13
        
        flipButton.frame = CGRect(x: previewViewContainer.frame.maxX-buttonWidth-2,
                                  y: previewViewContainer.frame.maxY-buttonWidth-2,
                                  width: buttonWidth, height: buttonWidth)
        
        flipButton.backgroundColor = UIColor.clear
        flipButton.layer.cornerRadius = buttonWidth/2
        flipButton.layer.borderWidth = 2
        flipButton.layer.borderColor = UIColor.white.cgColor
        flipButton.layer.masksToBounds = true
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        self.view.addSubview(flipButton)
    }
    
}

extension CameraVC {
    
    @objc func focus(_ recognizer: UITapGestureRecognizer) {
        
        let point = recognizer.location(in: self.previewViewContainer)
        let viewsize = self.previewViewContainer.bounds.size
        let newPoint = CGPoint(x: point.y/viewsize.height, y: 1.0-point.x/viewsize.width)
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            
            try device?.lockForConfiguration()
            
        } catch _ {
            
            return
        }
        
        if device?.isFocusModeSupported(AVCaptureFocusMode.autoFocus) == true {
            
            device?.focusMode = AVCaptureFocusMode.autoFocus
            device?.focusPointOfInterest = newPoint
        }
        
        if device?.isExposureModeSupported(AVCaptureExposureMode.continuousAutoExposure) == true {
            
            device?.exposureMode = AVCaptureExposureMode.continuousAutoExposure
            device?.exposurePointOfInterest = newPoint
        }
        
        device?.unlockForConfiguration()
        
        self.focusView?.alpha = 0.0
        self.focusView?.center = point
        self.focusView?.backgroundColor = UIColor.clear
        self.focusView?.layer.borderColor = UIColor.white.cgColor
        self.focusView?.layer.borderWidth = 1.0
        self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.previewViewContainer.addSubview(self.focusView!)
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3.0, options: UIViewAnimationOptions.curveEaseIn, // UIViewAnimationOptions.BeginFromCurrentState
            animations: {
                self.focusView!.alpha = 1.0
                self.focusView!.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {(finished) in
            self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.focusView!.removeFromSuperview()
        })
    }
    
    func flashConfiguration() {
        
        do {
            
            if let device = device {
                
                guard device.hasFlash else { return }
                
                try device.lockForConfiguration()
                
                device.flashMode = AVCaptureFlashMode.off
                flashButton.setImage(flashOffImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                
                device.unlockForConfiguration()
                
            }
            
        } catch _ {
            
            return
        }
    }
    
    func cameraIsAvailable() -> Bool {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            
            return true
        }
        
        return false
    }
}
