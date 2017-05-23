//
//  ColorListTVC.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import Foundation

struct ColorItem {
    var colorName: String
    var colorArray: [String]
}

class ColorListTVC: UITableViewController, UISearchBarDelegate {
    var filterItemArray = [ColorItem]()
    var itemArray = [ColorItem]()
    var sectionCount: Int = 0
    var arrData = NSArray()
    var filterColorName = [String]()
    var searchController = UISearchController()
    var id: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.barTintColor = UIColor.lightGray
        
        searchController.searchBar.placeholder = "eg. #ffffff"
        
        
        self.navigationItem.title = "Palettes"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadData()
        
        getData()
    }
    
    //MARK: Lấy dữ liệu từ server truyền vào mảng itemArray
    
    func getData() {
        
        let data = NSData(contentsOf: NSURL(string: "http://192.168.1.106:3000/") as! URL)
        
        
    }
//        __dispatch_async(DispatchQueue.global(), {
//            let url = URL(string: "http://192.168.1.107:3001/all")
//            do {
//                let allData = try Data(contentsOf: url!)
//                let allColor = try JSONSerialization.jsonObject(with: allData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
//                if let arrJSON = allColor["data"] {
//                    for index in 0..<arrJSON.count
//                    {
//                        let aObject = arrJSON[index] as! [String: AnyObject]
//                        
//                        self.id.append(aObject["id"] as! String)
//                    }
//                }
//                for i in 0..<self.id.count
//                {
//                    let url = URL(string: "http://192.168.1.107:3001/detailios/\(self.id[i])")
//                    do {
//                        let colorData = try Data(contentsOf: url!)
//                        let allColor = try JSONSerialization.jsonObject(with: colorData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
//                        if let arrJSON = allColor["data"] {
//                            for index in 0..<arrJSON.count{
//                                let aObject = arrJSON[index] as! [String: AnyObject]
//                                
//                            
//                            }
//                        }
//                    }
//                }
//            }
//            catch
//            {
//            }
//        })
    
    
    //MARK: Lấy dữ liệu từ file plist truyền vào mảng itemArray
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
                if itemArray[i].colorArray[j].lowercased().contains(code.lowercased()) == true{
                    
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
    
    //MARK: Tạo cell chứa palettes liên quan đến mã màu ở searchBar
    func createCellFilter(section: Int) -> UITableViewCell {
        let cell = ColorListCell()
        for index in 0..<arrData.count{
            
            let itemDict = arrData[index] as! NSDictionary
            
            let item = itemDict["data"] as! NSArray
            let name = itemDict["name"] as! String
            
            if filterColorName[section] == name {
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
                cell.backgroundColor = UIColor.clear
            }
        }
        return cell
    }
    
    //MARK: Tạo cell
    func createCell(section: Int) -> UITableViewCell {
        let cell = ColorListCell()
        let itemDict = arrData[section] as! NSDictionary
        
        let item = itemDict["data"] as! NSArray
        
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
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.textColor = UIColor.black
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
        return arrData.count
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
extension ColorListTVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterColor(code: searchController.searchBar.text!)
    }
}









