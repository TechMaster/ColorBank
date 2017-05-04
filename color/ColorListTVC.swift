//
//  ColorListTVC.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

struct ColorItem {
    var colorName: String
    var colorArray: [String]
}

class ColorListTVC: UITableViewController {
    
    
    var colorItemArray = [ColorItem]()
    var sectionCount: Int = 0
    var arrData = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadData()
    }
    func loadData(){
        
        var dictData = NSDictionary()
        var path: String = ""
        
        path = Bundle.main.path(forResource:"colorData", ofType: "plist")!
        dictData = NSDictionary(contentsOfFile: path)!
        arrData = dictData["data"] as! NSArray
        
        for index in 0..<arrData.count{
            
            let itemDict = arrData[index] as! NSDictionary
            
            let item = itemDict["data"] as! NSArray
            let name = itemDict["name"] as! String
            
            colorItemArray.append(ColorItem(colorName: name, colorArray: item as! [String]))
            
        }
        
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.size.width/5
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return colorItemArray[section].colorName
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ColorListCell()
        
        let itemDict = arrData[indexPath.section] as! NSDictionary
        
        let item = itemDict["data"] as! NSArray
        
        //#1 Lấy dữ liệu truyền vào ColorListCell
        
        cell.color0 = item[0] as! String
        cell.color1 = item[1] as! String
        cell.color2 = item[2] as! String
        cell.color3 = item[3] as! String
        cell.color4 = item[4] as! String
        
        cell.cell = ColorBar(frame: CGRect(x: 0, y: 0,
                                      width: self.view.bounds.size.width,
                                      height: self.view.bounds.size.width/5),
                        color_0: cell.color0,
                        color_1: cell.color1,
                        color_2: cell.color2,
                        color_3: cell.color3,
                        color_4: cell.color4)
        cell.addSubview(cell.cell)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    
}
