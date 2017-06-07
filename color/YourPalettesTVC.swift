//
//  ColorListTVC.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import Foundation
import Fusuma

class YourPalettesTVC: UITableViewController, UISearchBarDelegate {
    var filterItemArray = [ColorItem]()
    var itemArray = [ColorItem]()
    var sectionCount: Int = 0
    var arrData = NSArray()
    var filterColorName = [String]()
    var searchController = UISearchController()
    var id: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Palettes"
        tableView.delegate = self
        tableView.dataSource = self
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName:UIColor(hexString: "#F38181")]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        self.searchController.searchBar.placeholder = "E.g. #FFFFFF or Giant Goldfish"
        self.searchController.searchBar.setTextColor(color: UIColor(hexString: "#F38181"))
        self.searchController.searchBar.setPlaceholderTextColor(color: UIColor(hexString: "#F38181"))
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#F38181")
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor(hexString: "#F38181"),
             NSFontAttributeName: UIFont(name: "American Typewriter", size: 20)!]
        self.navigationItem.title = "Your Palettes"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //        loadDataFromPlist()
        
        //Check internet connection
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            loadDataFromPlist()
        case .online(.wwan):
            print("Connected via WWAN")
            loadDataFromServer()
        case .online(.wiFi):
            print("Connected via WiFi")
            loadDataFromServer()
        }
    }
    
    //MARK: Lấy dữ liệu từ server truyền vào mảng itemArray
    
    func loadDataFromServer() {
        __dispatch_async(DispatchQueue.global(), {
            let url = URL(string: "http://192.168.1.105:3001/all")
            do {
                let allData = try Data(contentsOf: url!)
                let allColor = try JSONSerialization.jsonObject(with: allData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                if let arrJSON = allColor["data"] as? NSArray {
                    for index in 0..<arrJSON.count
                    {
                        let aObject = arrJSON[index] as! [String: AnyObject]
                        self.id.append(aObject["id"] as! String)
                    }
                }
                for i in 0..<self.id.count
                {
                    let url = URL(string: "http://192.168.1.105:3001/detailios/\(self.id[i])")
                    do {
                        let colorData = try Data(contentsOf: url!)
                        let allColor = try JSONSerialization.jsonObject(with: colorData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                        if let arrJSON = allColor["data"] as? NSArray {
                            for index in 0..<arrJSON.count
                            {
                                let aObject = arrJSON[index] as! [String: AnyObject]
                                var item = [String]()
                                item.append(aObject["color1"]! as! String)
                                item.append(aObject["color2"]! as! String)
                                item.append(aObject["color3"]! as! String)
                                item.append(aObject["color4"]! as! String)
                                item.append(aObject["color5"]! as! String)
                                self.itemArray.append(ColorItem(colorName: aObject["name"]! as! String, colorArray: item ))
                                __dispatch_async(DispatchQueue.main, {
                                    self.tableView.reloadData()
                                })
                            }
                        }
                    }
                }
            }
            catch
            {
            }
        })
    }
    
    
    //MARK: Lấy dữ liệu từ file plist truyền vào mảng itemArray
    func loadDataFromPlist(){
        
        var notesArray = NSMutableArray()
        var pathPlist: String = ""
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        pathPlist = appDelegate.plistPathInDocument
        
        let data: Data = FileManager.default.contents(atPath: pathPlist)!
        do {
            notesArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
        }
        catch
        {
            print("reading error")
        }
        
        arrData = notesArray[0] as! NSArray
        for index in 0..<arrData.count{
            
            let itemDict = arrData[index] as! NSDictionary
            
            let item = itemDict["data"] as! NSArray
            let name = itemDict["name"] as! String
            
            itemArray.append(ColorItem(colorName: name, colorArray: item as! [String]))
            
        }
    }
    
    //MARK: Lọc mã màu
    func filterColor(code: String){ // code là mã màu được viết ở searchBar
        
        filterColorName.removeAll()
        filterItemArray.removeAll()
        
        //Vào trong mảng itemArray
        for i in 0..<itemArray.count{
            
            //Vào trong mảng colorArray
            for j in 0..<itemArray[i].colorArray.count{
                
                //Kiểm tra nếu mảng colorArray chứa code
                if itemArray[i].colorArray[j].lowercased().contains(code.lowercased()) == true || itemArray[i].colorName.lowercased().contains(code.lowercased()) == true {
                    
                    //Nếu mảng filterColorName chưa chứa tên màu đó thì append tên màu đó vào
                    if filterColorName.contains(itemArray[i].colorName) == false
                    {
                        filterColorName.append(itemArray[i].colorName)
                        filterItemArray.append(itemArray[i])
                    }
                    else
                    {
                        break
                    }
                }
                
            }
        }
        tableView.reloadData()
    }
    
    //MARK: Tạo cell khi dùng đến searchBar
    func createCellFilter(section: Int) -> UITableViewCell {
        let cell = ColorListCell()
        for index in 0..<itemArray.count
        {
            let name = itemArray[index].colorName
            let item = itemArray[index].colorArray
            if filterColorName[section] == name {
                cell.color0 = item[0]
                cell.color1 = item[1]
                cell.color2 = item[2]
                cell.color3 = item[3]
                cell.color4 = item[4]
                
                cell.cell = ColorBar(frame: CGRect(x: 0, y: 0,
                                                   width: self.view.bounds.size.width,
                                                   height: self.view.bounds.size.width/5),
                                     color_0: cell.color0,
                                     color_1: cell.color1,
                                     color_2: cell.color2,
                                     color_3: cell.color3,
                                     color_4: cell.color4)
                cell.addSubview(cell.cell)
                cell.backgroundColor = UIColor.clear
            }
            
        }
        return cell
    }
    
    //MARK: Tạo cell
    func createCell(section: Int) -> UITableViewCell {
        let cell = ColorListCell()
        let item = itemArray[section].colorArray
        
        cell.color0 = item[0]
        cell.color1 = item[1]
        cell.color2 = item[2]
        cell.color3 = item[3]
        cell.color4 = item[4]
        
        cell.cell = ColorBar(frame: CGRect(x: 0, y: 0,
                                           width: self.view.bounds.size.width,
                                           height: self.view.bounds.size.width/5),
                             color_0: cell.color0,
                             color_1: cell.color1,
                             color_2: cell.color2,
                             color_3: cell.color3,
                             color_4: cell.color4)
        cell.addSubview(cell.cell)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.size.width/5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.bounds.size.width/15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "American Typewriter", size: 25)
        header.textLabel?.textColor = UIColor(hexString: "#F38181")
        header.textLabel?.textAlignment = .center
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive == true && searchController.searchBar.text != "" {
            return filterColorName[section]
        }
        return itemArray[section].colorName
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive == true && searchController.searchBar.text != "" {
            return filterColorName.count
        }
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController.isActive == true && searchController.searchBar.text != "" {
            return createCellFilter(section: indexPath.section)
        }
        else
        {
            return createCell(section: indexPath.section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let detailColorVC = DetailColorVC()
        if searchController.isActive == true && searchController.searchBar.text != "" {
            detailColorVC.colorArr = filterItemArray
            detailColorVC.indexSection = indexPath.section
        }else
        {
            detailColorVC.colorArr = itemArray
            detailColorVC.indexSection = indexPath.section
            
        }
        self.navigationController?.pushViewController(detailColorVC, animated: true)}
    
}
//MARK: Update SearchBar
extension YourPalettesTVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterColor(code: searchController.searchBar.text!)
    }
}
