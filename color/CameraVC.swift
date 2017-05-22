//
//  TestVC.swift
//  color
//
//  Created by NhatMinh on 5/22/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    let previewView = UIView()
    let takePhotoBtn = UIButton()
    let capturedImage = UIImageView()
    let flashBtn = UIButton()
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        createPreviewView()
        createTakePhotoBtn()
        createCapturedImage()
        createFlashBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetHigh
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input){
            
            session!.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if session!.canAddOutput(stillImageOutput) {
                session!.addOutput(stillImageOutput)
            }
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            previewView.layer.addSublayer(videoPreviewLayer!)
            session!.startRunning()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
        
    }
    
    func createPreviewView() {
        let navHeight = self.navigationController?.navigationBar.bounds.size.height
        let screenWidth = self.view.bounds.size.width
        let statusHeight = UIApplication.shared.statusBarFrame.height
        previewView.frame = CGRect(x: 10, y: navHeight! + statusHeight + 10, width: screenWidth - 20, height: screenWidth - 20)
        previewView.layer.cornerRadius = 8
        previewView.layer.masksToBounds = true

        self.view.addSubview(previewView)
    }
    
    func createTakePhotoBtn() {
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        let buttonWidth = screenWidth/6
        
        takePhotoBtn.frame = CGRect(x: screenWidth/2 - buttonWidth/2,
                                    y: (screenHeight-previewView.frame.maxY)/2 - buttonWidth/2 + previewView.frame.maxY,
                                    width: buttonWidth,
                                    height: buttonWidth)
        takePhotoBtn.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        takePhotoBtn.backgroundColor = UIColor.cyan
        self.view.addSubview(takePhotoBtn)
    }
    
    func createCapturedImage() {
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        let buttonWidth = screenWidth/6
        
        capturedImage.frame = CGRect(x: screenWidth - 10 - buttonWidth,
                                     y: (screenHeight-previewView.frame.maxY)/2 - buttonWidth/2 + previewView.frame.maxY,
                                     width: buttonWidth,
                                     height: buttonWidth)
        capturedImage.backgroundColor = UIColor.brown
        self.view.addSubview(capturedImage)
    }
    
    func createFlashBtn(){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        let buttonWidth = screenWidth/6
        
        flashBtn.frame = CGRect(x: 10,
                                y: (screenHeight-previewView.frame.maxY)/2 - buttonWidth/2 + previewView.frame.maxY,
                                width: buttonWidth,
                                height: buttonWidth)
        flashBtn.backgroundColor = UIColor.red
        flashBtn.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        self.view.addSubview(flashBtn)
        
    }
    
    func didTakePhoto(){
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            // ...
            // Code for photo capture goes here...
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                // ...
                // Process the image data (sampleBuffer) here to get an image file we can put in our captureImageView
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    // ...
                    // Add the image to captureImageView here...
                    self.capturedImage.image = image
                    
                }
            })
        }
    }
    
    func toggleFlash() {
        
        var device : AVCaptureDevice!

        if #available(iOS 10.0, *) {
            let videoDeviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDuoCamera], mediaType: AVMediaTypeVideo, position: .unspecified)!
            let devices = videoDeviceDiscoverySession.devices!
            device = devices.first!
            
        } else {
            // Fallback on earlier versions
            device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        }
        
        if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
            if (device.hasTorch) {
                self.session?.beginConfiguration()
                //self.objOverlayView.disableCenterCameraBtn();
                if device.isTorchActive == false {
                    self.flashOn(device: device)
                } else {
                    self.flashOff(device: device);
                }
                //self.objOverlayView.enableCenterCameraBtn();
                self.session?.commitConfiguration()
            }
        }
    }
    
    private func flashOn(device:AVCaptureDevice) {
        do{
            if (device.hasTorch) {
                try device.lockForConfiguration()
                device.torchMode = .on
                device.flashMode = .on
                device.unlockForConfiguration()
            }
        }catch{
            //DISABEL FLASH BUTTON HERE IF ERROR
            print("Device tourch Flash Error ");
        }
    }
    
    private func flashOff(device:AVCaptureDevice) {
        do{
            if (device.hasTorch) {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.flashMode = .off
                device.unlockForConfiguration()
            }
        }catch{
            //DISABEL FLASH BUTTON HERE IF ERROR
            print("Device tourch Flash Error ");
        }
    }
    
    private func flashAuto(device:AVCaptureDevice) {
        do{
            if (device.hasTorch) {
                try device.lockForConfiguration()
                device.torchMode = .auto
                device.flashMode = .auto
                device.unlockForConfiguration()
            }
        }catch{
            //DISABEL FLASH BUTTON HERE IF ERROR
            print("Device tourch Flash Error ");
        }
    }
    
    
    
}
