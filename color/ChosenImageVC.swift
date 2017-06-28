//
//  ChosenImageVC.swift
//  color
//
//  Created by NhatMinh on 4/28/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import Foundation
import UIKit

class ChosenImageVC: UIViewController, PassingDetectColorDelegate {
    
    var customPaletteColors = [ColorPalette]()
    var arrayFromPlist = NSMutableArray()
    let magView = YPMagnifyingView()
    var imageView = UIImageView()
    var image = UIImage()
    var getColorButton = ShotButton()
    var paletteView = UIView()
    var customPalette = [UILabel]()
    var customPaletteHexArray = [String]()
    let descriptionLabel = DescriptionLabel()
    let saveButton = UIButton()
    let undoButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#F38181")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hexString: "#F38181")]
        
        magView.delegate = self
        
        createMagGlassAndSniper()
        createGetColorButton()
        createCustomPaletteView()
        createUndoButton()
        createSaveButton()
        createBackButton()
        
        saveButton.isEnabled = false
        saveButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        undoButton.isEnabled = false
        undoButton.setTitleColor(UIColor.lightGray, for: .normal)
                
    }
    
    //MARK: Back Button
    func createBackButton(){
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(popView(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    func popView(sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: ImageView & MagnifyingView
    func createImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: self.magView.frame.size.width, height: self.magView.frame.size.height)
        imageView.image = image
        
    }
    
    func createMagGlassAndSniper(){
        
        let navHeight = self.navigationController?.navigationBar.bounds.size.height
        let screenWidth = self.view.bounds.size.width
        let statusHeight = UIApplication.shared.statusBarFrame.height
        
        magView.frame = CGRect(x: 10, y: navHeight! + statusHeight + 10, width: screenWidth - 20, height: screenWidth - 20)
        magView.layer.borderWidth = 1
        magView.layer.borderColor = UIColor.black.cgColor
        magView.layer.masksToBounds = true
        self.view.addSubview(magView)
        
        createImageView()
        
        magView.addSubview(imageView)
        
        let magGlass = YPMagnifyingGlass(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        magGlass.layer.cornerRadius = 8
        magGlass.scale = 4
        magView.magnifyingGlass = magGlass
        
        let focusPoint = YPMagnifyingGlass(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        focusPoint.layer.cornerRadius = focusPoint.frame.width/2
        focusPoint.scale = 20
        magView.focusPoint = focusPoint
        
        let sniper = Sniper(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        magView.sniper = sniper
        
        magView.addSniperAtPoint(point: magView.center)
        
        let color = magView.getPixelColorAtPoint(point: imageView.center, sourceView: magView)
        getColorButton.color = UIColor(hexString: color)
        getColorButton.setTitle(color, for: .normal)
    }
    
    
    //MARK: CustomPaletteView
    func createCustomPaletteView() {
        let paletteViewWidth = self.magView.bounds.size.width
        let paletteViewHeight = self.view.bounds.size.height - 15 - self.getColorButton.bounds.size.height - self.magView.frame.maxY
        paletteView.frame = CGRect(x: self.magView.frame.minX,
                                   y: self.magView.frame.maxY,
                                   width: paletteViewWidth,
                                   height: paletteViewHeight)
        self.view.addSubview(paletteView)
        
        descriptionLabel.frame = self.paletteView.bounds
        descriptionLabel.text = "Press the circle button to pick a color"
        descriptionLabel.textColor = UIColor(hexString: "#F38181")
        descriptionLabel.font = UIFont(name: "American Typewriter", size: 20)
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.layer.zPosition = -1
        
        self.paletteView.addSubview(descriptionLabel)
        
        
    }
    
    
    //MARK: method to pass color via protocol-delegate
    func passColor(hexString: String) {
        getColorButton.color = UIColor(hexString: hexString)
        getColorButton.setTitle(hexString, for: .normal)
    }
    
    //MARK: GetColor Button
    func createGetColorButton(){
        
        let buttonWidth = (self.view.bounds.size.height - self.magView.frame.maxY)/2 - 15
        
        getColorButton.frame = CGRect(x: self.view.bounds.size.width/2 - buttonWidth/2,
                                      y: self.view.bounds.size.height - buttonWidth - 7.5,
                                      width: buttonWidth,
                                      height: buttonWidth)
        getColorButton.addTarget(self, action: #selector(getColor), for: .touchUpInside)
        getColorButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        getColorButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(getColorButton)
    }
    
    func getColor() {
        self.descriptionLabel.isHidden = true
        
        if customPalette.count < 5 {
            let screenWidth = self.view.bounds.size.width
            let paletteViewWidth = self.paletteView.bounds.size.width
            let paletteViewHeight = self.paletteView.bounds.size.height
            let newColor = UILabel()
            newColor.frame = CGRect(x: screenWidth*6/5,
                                    y: paletteView.frame.minY,
                                    width: paletteViewWidth/5,
                                    height: paletteViewHeight)
            newColor.backgroundColor = getColorButton.color
            newColor.layer.borderWidth = 2
            newColor.layer.borderColor = getColorButton.color.cgColor
            customPalette.append(newColor)
            customPaletteHexArray.append((newColor.backgroundColor?.toHexString)!)
            
            
            if customPalette.count > 0{
                undoButton.isEnabled = true
                undoButton.setTitleColor(UIColor(hexString: "#F38181"), for: .normal)
            }else{
                undoButton.isEnabled = false
                undoButton.setTitleColor(UIColor.lightGray, for: .normal)
                
            }
            
            if customPalette.count == 5{
                saveButton.isEnabled = true
                saveButton.setTitleColor(UIColor(hexString: "#F38181"), for: .normal)
            }else{
                saveButton.isEnabled = false
                saveButton.setTitleColor(UIColor.lightGray, for: .normal)
                
            }
            
            self.view.addSubview(newColor)
            
            UIView.animate(withDuration: 1, animations: {
                newColor.center.x = self.magView.frame.minX + self.paletteView.bounds.size.width*(CGFloat(self.customPalette.count)/5) - (newColor.frame.size.width/2)
            })
        }
    }
    
    //MARK: Save Button
    func createSaveButton(){
        
        let buttonWidth = (self.view.bounds.size.height - self.magView.frame.maxY)/2 - 15
        
        saveButton.frame = CGRect(x: self.view.bounds.size.width - buttonWidth - 10,
                                  y: self.view.bounds.size.height - buttonWidth - 7.5,
                                  width: buttonWidth,
                                  height: buttonWidth)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 20)
        saveButton.titleLabel?.textAlignment = .center
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        self.view.addSubview(saveButton)
    }
    
    func save(){
        let alertController = UIAlertController(title: "Add New Palette", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let textField = alertController.textFields![0] as UITextField
            
            //Save new palette to plist
            let dict = ["data" : [self.customPaletteHexArray[0],
                                  self.customPaletteHexArray[1],
                                  self.customPaletteHexArray[2],
                                  self.customPaletteHexArray[3],
                                  self.customPaletteHexArray[4]],
                        "name" : textField.text!] as [String : Any]
            self.saveDataToPlist(dict: dict as NSDictionary, customPaletteName: textField.text!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Palette Name"
            textField.textAlignment = .center
            
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveDataToPlist(dict: NSDictionary, customPaletteName: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let pathForThePlistFile = appDelegate.plistPathYourPalettes
        
        // Extract the content of the file as NSData
        print(pathForThePlistFile)
        let data:NSData =  FileManager.default.contents(atPath: pathForThePlistFile)! as NSData
        // Convert the NSData to mutable array
        do{
            arrayFromPlist = try PropertyListSerialization.propertyList(from: data as Data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
            (arrayFromPlist[0] as AnyObject).add(dict)
            // Save to plist
            arrayFromPlist.write(toFile: pathForThePlistFile, atomically: true)
            
        }catch {
            print("An error occurred while writing to plist")
        }
        
        YourPalettesTVC().tableView.reloadData()
        let yourPalettesTVC = YourPalettesTVC()
        yourPalettesTVC.scrollToBottom = true
        self.navigationController?.pushViewController(yourPalettesTVC, animated: true)
    }
    
    //MARK: Undo Button
    func createUndoButton(){
        
        let buttonWidth = (self.view.bounds.size.height - self.magView.frame.maxY)/2 - 15
        
        undoButton.frame = CGRect(x: 10,
                                  y: self.view.bounds.size.height - buttonWidth - 7.5,
                                  width: buttonWidth,
                                  height: buttonWidth)
        undoButton.setTitle("Undo", for: .normal)
        undoButton.setTitleColor(UIColor(hexString: "#F38181"), for: .normal)
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        undoButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 20)
        undoButton.titleLabel?.textAlignment = .center
        self.view.addSubview(undoButton)
        
    }
    
    func undo(){
        
        saveButton.isEnabled = false
        saveButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        if customPalette.count>0{
            
            let lastColor = customPalette[(customPalette.count-1)]
            
            lastColor.removeFromSuperview()
            self.customPalette.removeLast()
            self.customPaletteHexArray.removeLast()
            
            if customPalette.count == 0{
                self.descriptionLabel.isHidden = false
                undoButton.isEnabled = false
                undoButton.setTitleColor(UIColor.lightGray, for: .normal)
            }
            
        }
    }
}

class DescriptionLabel: UILabel {
    override func draw(_ rect: CGRect) {
        let  insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        
    }
}
