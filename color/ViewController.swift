//
//  ViewController.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createColorListButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createColorListButton(){
        let colorListButon = UIButton()
        colorListButon.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        colorListButon.backgroundColor = UIColor.black
        colorListButon.addTarget(self, action: #selector(pushToTableView), for: .touchUpInside)
        self.view.addSubview(colorListButon)
    }
    
    func pushToTableView(){
        let newViewController = TableViewVC()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

}

