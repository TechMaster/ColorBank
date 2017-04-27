//
//  MainScreen.swift
//  TechmasterSwiftApp


import UIKit

struct Menu {
    var title : ColorBar
    var viewClass: String
}

struct MenuSection {
    var section: String
    var menus: [Menu]
}

class TableViewVC: UITableViewController {
    var about: String!
    
    var menu: [MenuSection]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButoonItem = UIBarButtonItem(title: "About", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TableViewVC.onAbout))
        self.navigationItem.rightBarButtonItem = barButoonItem
        
        self.tableView.contentInset = UIEdgeInsetsMake(20,0,0,0)
        
    }
    
    func onAbout(){
        let alert = UIAlertController.init(title: "Info",
                                           message: about,
                                           preferredStyle: .alert)
        
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let menuSection: MenuSection  = self.menu[section]
        let menuArray: [Menu] = menuSection.menus
        
        return menuArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let menuSection: MenuSection = self.menu[section]
        return menuSection.section
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.bounds.size.width/5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "id")
        let menuSection: MenuSection = self.menu[indexPath.section]
        let menuItems = menuSection.menus
        let item: Menu = menuItems[indexPath.row]
        cell.backgroundView = item.title
        cell.accessoryType = .none
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuSection: MenuSection = self.menu[indexPath.section]
        let menuItems = menuSection.menus
        let item: Menu = menuItems[indexPath.row]
        let xibClass = item.viewClass
        let detailScreen: UIViewController!
        let appName =  Bundle.main.infoDictionary!["CFBundleName"] as! String
        // check if class exits
        if let aClass = NSClassFromString("\(appName).\(xibClass)") as? UIViewController.Type {
            
            if (Bundle.main.path(forResource: xibClass, ofType: "nib") == nil){
                //if the xib file does not exits
                detailScreen = aClass.init() as UIViewController
            }else{
                detailScreen = aClass.init(nibName:xibClass,bundle:nil) as UIViewController
                
            }
            //            detailScreen.title = item.title
            (detailScreen as! DetailColorVC).delegateMain = self
            (detailScreen as! DetailColorVC).indexSection = indexPath.section
            
            self.navigationController!.pushViewController(detailScreen, animated: true)
            
        }else{
            let alert = UIAlertController.init(title: "Warning",
                                               message: "Please implement screen \(xibClass)",
                preferredStyle: .alert)
            
            let defaultAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
