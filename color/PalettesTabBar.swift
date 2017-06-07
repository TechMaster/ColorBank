//
//  Palettes.swift
//  color
//
//  Created by Loc Tran on 6/7/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class PalettesTabBar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = AllPalettesTVC()
        let tabOneBarItem = UITabBarItem(title: "All", image: nil, selectedImage: nil)
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = YourPalettesTVC()
        let tabTwoBarItem = UITabBarItem(title: "Your Palettes", image: nil, selectedImage: nil)
        
        tabTwo.tabBarItem = tabTwoBarItem
        
        
        self.viewControllers = [tabOne, tabTwo]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
    
    
}
