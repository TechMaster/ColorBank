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
    
    var itemArray = [ColorItem]()
    var sectionCount: Int = 0
    var arrData = NSArray()
    var filterColorName = [String]()
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.title = "Palettes"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func filterColor(code: String){
        filterColorName.removeAll()
        for i in 0..<itemArray.count{
            for j in 0..<itemArray[i].colorArray.count{
                if itemArray[i].colorArray[j].lowercased().contains(code.lowercased()) == true{
                    if filterColorName.contains(itemArray[i].colorName) == false
                    {
                        filterColorName.append(itemArray[i].colorName)
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
        let cell = ColorListCell()
        if searchController.isActive == true && searchController.searchBar.text != "" {
            
        }
        else
        {
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
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailColorVC = DetailColorVC()
        
        detailColorVC.colorArr = itemArray
        detailColorVC.indexSection = indexPath.section
        tableView.reloadData()
        self.navigationController?.pushViewController(detailColorVC, animated: true)
    }
    
    
}

extension ColorListTVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterColor(code: searchController.searchBar.text!)
    }
}









