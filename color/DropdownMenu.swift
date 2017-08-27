//
//  DropDown.swift
//  color
//
//  Created by Loc Tran on 6/28/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

//import Foundation
//import UIKit
//
//protocol DropDownDelegate {
//    func dropDownSelection(index: Int)
//}
//
//class DropdownMenu: UIView, UITableViewDelegate, UITableViewDataSource {
//    
//    var tableView: UITableView!
//    var action: [String] = ["Offline Palettes", "Online Palettes"]
//    var delegate: DropDownDelegate!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.layer.backgroundColor = UIColor.black.cgColor
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    func addTableView() {
//        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.addSubview(tableView)
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return action.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//        cell.textLabel?.text = action[indexPath.row]
//        cell.textLabel?.textColor = UIColor(hexString: "#F38181")
//        cell.textLabel?.font = UIFont(name: "American Typewriter", size: 20)
//        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        return cell
//        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.tableView.frame.size.height/2
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate.dropDownSelection(index: indexPath.row)
//    
//    }
//
//}
