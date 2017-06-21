//
//  MergePlist.swift
//  color
//
//  Created by NhatMinh on 6/21/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class MergePlist {
    var mainPlistPalettesArray = [ColorPalette]()
    var subPlistPalettesArray = [ColorPalette]()
    var arrayFromPlist = NSMutableArray()
    
    //MARK: Lấy dữ liệu từ file plist truyền vào mảng palettesArray
    func loadDataFromPlist(plistPath: String, palettesArray: [ColorPalette]){
        var palettesArray = palettesArray
        var arrayPalettesFromPlist = NSMutableArray()
        
        let data: Data = FileManager.default.contents(atPath: plistPath)!
        do {
            arrayPalettesFromPlist = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("reading error")
        }
        
        let arrData = arrayPalettesFromPlist[0] as! NSArray
        for index in 0..<arrData.count{
            print(index)
            let itemDict = arrData[index] as! NSDictionary
            
            let item = itemDict["data"] as! NSArray
            let name = itemDict["name"] as! String
            
            palettesArray.append(ColorPalette(colorName: name, colorArray: item as! [String]))
        }
        print(palettesArray.count)

    }
    
    func saveDataToPlist(dict: NSDictionary, plistPath: String){
        
        let data:NSData =  FileManager.default.contents(atPath: plistPath)! as NSData
        // Convert the NSData to mutable array
        do{
            self.arrayFromPlist = try PropertyListSerialization.propertyList(from: data as Data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
            (self.arrayFromPlist[0] as AnyObject).add(dict)
            // Save to plist
            self.arrayFromPlist.write(toFile: plistPath, atomically: true)
        }catch{
            print("An error occurred while writing to plist")
        }
    }
    
    func saveUnmatchPalettesToMainPlist(plistPath: String, ummatchPalette: ColorPalette) {
        
        let data = [ummatchPalette.colorArray[0],
                    ummatchPalette.colorArray[1],
                    ummatchPalette.colorArray[2],
                    ummatchPalette.colorArray[3],
                    ummatchPalette.colorArray[4]]
        
        // Save new palette to plist
        
        let dict = ["data" : data,
                    "name" : ummatchPalette.colorName] as [String : Any]
        print(dict)
        self.saveDataToPlist(dict: dict as NSDictionary, plistPath: plistPath)
        
    }
    
    //MARK: Lọc những palettes trùng tên
    func filterColorPalettes(mainPlistPath: String, mainPlistFile: [ColorPalette], subPlistFile: [ColorPalette]){
        print(mainPlistFile.count)
        print(subPlistFile.count)
        //Vào trong file colorData.plist
        for i in 0..<mainPlistFile.count{
            
            //Vào trong file colorData270.plist
            for j in 0..<subPlistFile.count{
                
                //Kiểm tra xem tên của các palettes trong subPlistFile có trùng với trong mainPlistFile hay không
                if mainPlistFile[i].colorName == subPlistFile[j].colorName {
                    return
                }
                    
                    //Nếu không thì lưu vào mainPlistFile
                else {
                    self.saveUnmatchPalettesToMainPlist(plistPath: mainPlistPath, ummatchPalette: subPlistFile[j])
                }
            }
        }
    }
}


