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

class YourPalettesTVC: UITableViewController, UISearchBarDelegate, FusumaDelegate {
    var filterItemArray = [ColorPalette]()
    var palettesArray = [ColorPalette]()
    var filterColorName = [String]()
    var searchController = UISearchController()
    var arrayPalettesFromPlist = NSMutableArray()
    var pathPlist: String = ""
    var deletePalettetIndexPath: IndexPath? = nil
    var scrollToBottom = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDataFromPlist()
        self.tableView.reloadData()
        
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
        
        createBackButton()
        createAddNewPaletteButton()
        
    }
    
    //MARK: Back Button
    func createBackButton(){
        
        //Create back button of type custom
        let myBackButton:UIButton = UIButton.init(type: .custom)
        myBackButton.addTarget(self, action: #selector(popToRootView(sender:)), for: .touchUpInside)
        myBackButton.setTitle("Back", for: .normal)
        myBackButton.setTitleColor(UIColor(hexString: "#F38181"), for: .normal)
        myBackButton.sizeToFit()
        
        //Add back button to navigationBar as left Button
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem
        
    }
    
    
    func popToRootView(sender:UIBarButtonItem){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Add Button
    func createAddNewPaletteButton(){
        //Create back button of type custom
        
        let myAddButton:UIButton = UIButton.init(type: .custom)
        myAddButton.addTarget(self, action: #selector(pushToMediaView(sender:)), for: .touchUpInside)
        myAddButton.setTitle("\u{002B}", for: .normal)
        myAddButton.setTitleColor(UIColor(hexString: "#F38181"), for: .normal)
        myAddButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 40)
        myAddButton.sizeToFit()
        
        //Add + button to navigationBar as right Button
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myAddButton)
        self.navigationItem.rightBarButtonItem = myCustomBackButtonItem
    }
    
    
    //MARK: Media
    func pushToMediaView(sender: UIBarButtonItem) {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self as FusumaDelegate
        fusuma.hasVideo = false // If you want to let the users allow to use video.
        self.navigationController?.pushViewController(fusuma, animated: true)
        
    }
    
    //MARK:  select image delegate
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        let newViewController = ChosenImageVC()
        newViewController.image = image
        self.navigationController?.pushViewController(newViewController, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func fusumaWillClosed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Lấy dữ liệu từ file plist truyền vào mảng itemArray
    func loadDataFromPlist(){
        DispatchQueue.global(qos: .background).async {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.pathPlist = appDelegate.plistPathYourPalettes
            
            let data: Data = FileManager.default.contents(atPath: self.pathPlist)!
            
            do {
                self.arrayPalettesFromPlist = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
            }
            catch {
                print("reading error")
            }
            
            let arrData = self.arrayPalettesFromPlist[0] as! NSArray
            for index in 0..<arrData.count{
                
                let itemDict = arrData[index] as! NSDictionary
                
                let item = itemDict["data"] as! NSArray
                let name = itemDict["name"] as! String
                
                self.palettesArray.append(ColorPalette(colorName: name, colorArray: item as! [String]))
                
            }
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
                    if filterColorName.contains(palettesArray[i].colorName) == false{
                        filterColorName.append(palettesArray[i].colorName)
                        filterItemArray.append(palettesArray[i])
                    }else {
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
        for index in 0..<palettesArray.count{
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
    
    //MARK: Delete Palette
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePalettetIndexPath = indexPath
            let paletteToDelete = palettesArray[indexPath.row].colorName
            confirmDelete(palette: paletteToDelete)
        }
    }
    
    func confirmDelete(palette: String) {
        let alert = UIAlertController(title: "Delete Palette", message: "Are you sure you want to permanently delete \(palette)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePalettetIndexPath {
            tableView.beginUpdates()
            DetailColorVC().check = 0
            (arrayPalettesFromPlist[0] as AnyObject).removeObject(at: indexPath.section)
            palettesArray.remove(at: indexPath.section)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            print(indexPath.section)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.deleteSections([indexPath.section], with: .automatic)
            arrayPalettesFromPlist.write(toFile: pathPlist, atomically: true)
            
            deletePalettetIndexPath = nil
            self.tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deletePalettetIndexPath = nil
    }
    
    
    //MARK: - Table view data source
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
        }else {
            return createCell(section: indexPath.section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let detailColorVC = DetailColorVC()
        if searchController.isActive == true && searchController.searchBar.text != "" {
            detailColorVC.colorArr = filterItemArray
            detailColorVC.indexSection = indexPath.section
        }else {
            detailColorVC.colorArr = palettesArray
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
