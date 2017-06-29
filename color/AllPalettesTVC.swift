//
//  ColorListTVC.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import Foundation

struct ColorPalette {
    var colorName: String
    var colorArray: [String]
}

class AllPalettesTVC: UITableViewController, UISearchBarDelegate, UIPopoverPresentationControllerDelegate, DropDownDelegate {
    
    var palettesArray = [ColorPalette]()
    var arrayFromPlist = NSMutableArray()
    
    var filterColorName = [String]()
    var filterItemArray = [ColorPalette]()
    var searchController = UISearchController()
    
    var indicator = UIActivityIndicatorView()
    
    let dropMenu = DropdownMenu()
    var dropDownIsShowing: Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.backgroundColor = UIColor.white
        
        setupSearchController()
        setupNavigationBar()
        
        loadingIndicator()
        createSettingButton()
        createBackButton()
        
        dropDownIsShowing = false
        createDropDownMenu()
        dropMenu.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: Check internet connection
        loadDataFromPlist()
    }
    
    //MARK: NavigationBar
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#F38181")
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor(hexString: "#F38181"),
             NSFontAttributeName: UIFont(name: "American Typewriter", size: 20)!]
        self.navigationItem.title = "Palettes"
    }
    
    //MARK: Search Controller
    func setupSearchController(){
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
    }
    
    //MARK: Back Button
    func createBackButton(){
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(popView(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func popView(sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Setting Button
    func createSettingButton(){
        let settingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(settingAction))
        self.navigationItem.rightBarButtonItem = settingButton
        
    }
    
    func settingAction(){
        
        if dropDownIsShowing == false{
            dropMenu.isHidden = false
            tableView.tableHeaderView?.isUserInteractionEnabled = false
            dropDownIsShowing = true
        }else{
            dropMenu.isHidden = true
            tableView.tableHeaderView?.isUserInteractionEnabled = true
            dropDownIsShowing = false
        }

    }
    
    func createDropDownMenu(){
        
        dropMenu.frame = CGRect(x: self.view.frame.width*2/3, y: (self.tableView.tableHeaderView?.frame.minY)!, width: self.view.bounds.size.width/3, height: self.view.bounds.size.width/5)
        dropMenu.delegate = self
        dropMenu.addTableView()
        dropMenu.layer.zPosition = CGFloat.greatestFiniteMagnitude
        self.view.addSubview(dropMenu)

    }
    
    func dropDownSelection(index: Int) {
        
        dropMenu.isHidden = true
        dropDownIsShowing = false
        tableView.tableHeaderView?.isUserInteractionEnabled = true
        palettesArray.removeAll()

        if index == 0{
            loadDataFromPlist()
        }else{
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                print("Not connected")
                createAlertView(title: "No internet connection")
            case .online(.wwan):
                print("Connected via WWAN")
                loadDataFromServer()
            case .online(.wiFi):
                print("Connected via WiFi")
                loadDataFromServer()
            }
        }
        
        tableView.reloadData()

    }
    
    //MARK: Loading Indicator
    func loadingIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    //MARK: Connection fail alert
    func createAlertView(title: String) {
        let alertController = UIAlertController(title: title, message: "Press Ok to use offline palettes.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.palettesArray.removeAll()
            self.loadDataFromPlist()
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.navigationController?.popToRootViewController(animated: true)
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Lấy dữ liệu từ server truyền vào mảng itemArray
    func loadDataFromServer() {
        
        if palettesArray.count > 0 {
            return
        }
        
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "http://colornd.com/ios/all")
            do {
                let allData = try Data(contentsOf: url!)
                let allColor = try JSONSerialization.jsonObject(with: allData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
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
                        self.palettesArray.append(ColorPalette(colorName: aObject["name"]! as! String, colorArray: item ))
                        
                        
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
            }
            catch {
                self.createAlertView(title: "Cannot connect to server")
            }
            
        }
        
        print(palettesArray.count)
    }
    
    //MARK: Lấy dữ liệu từ file plist truyền vào mảng itemArray
    func loadDataFromPlist(){
        
        if palettesArray.count > 0 {
            return
        }
        
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
        
        var arrayPalettesFromPlist = NSMutableArray()
        var pathPlist: String = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        pathPlist = appDelegate.plistPathInDocument
        
        let data: Data = FileManager.default.contents(atPath: pathPlist)!
        do {
            arrayPalettesFromPlist = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch {
            print("reading error")
        }
        
        let arrData = arrayPalettesFromPlist[0] as! NSArray
        for index in 0..<arrData.count{
            
            let itemDict = arrData[index] as! NSDictionary
            
            let item = itemDict["data"] as! NSArray
            let name = itemDict["name"] as! String
            
            palettesArray.append(ColorPalette(colorName: name, colorArray: item as! [String]))
            
        }
        
    }
    
    //MARK: Lọc mã màu
    func filterColor(code: String){ // code là mã màu được viết ở searchBar
        
        filterColorName.removeAll()
        filterItemArray.removeAll()
        
        //Vào trong mảng itemArray
        for i in 0..<palettesArray.count{
            
            //Vào trong mảng colorArray
            for j in 0..<palettesArray[i].colorArray.count{
                
                //Kiểm tra nếu mảng colorArray chứa code
                if palettesArray[i].colorArray[j].lowercased().contains(code.lowercased()) == true || palettesArray[i].colorName.lowercased().contains(code.lowercased()) == true {
                    
                    //Nếu mảng filterColorName chưa chứa tên màu đó thì append tên màu đó vào
                    if filterColorName.contains(palettesArray[i].colorName) == false
                    {
                        filterColorName.append(palettesArray[i].colorName)
                        filterItemArray.append(palettesArray[i])
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
        for index in 0..<palettesArray.count
        {
            let name = palettesArray[index].colorName
            let item = palettesArray[index].colorArray
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
        let item = palettesArray[section].colorArray
        
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
        header.isUserInteractionEnabled = false
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive == true && searchController.searchBar.text != "" {
            return filterColorName[section]
        }
        return palettesArray[section].colorName
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive == true && searchController.searchBar.text != "" {
            return filterColorName.count
        }
        return palettesArray.count
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
        detailColorVC.check = 1
        if searchController.isActive == true && searchController.searchBar.text != "" {
            detailColorVC.colorArr = filterItemArray
            detailColorVC.indexSection = indexPath.section
        }else
        {
            detailColorVC.colorArr = palettesArray
            detailColorVC.indexSection = indexPath.section
        }
        self.navigationController?.pushViewController(detailColorVC, animated: true)}
    
}
//MARK: Update SearchBar
extension AllPalettesTVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterColor(code: searchController.searchBar.text!)
    }
}
