//
//  AboutUsVC.swift
//  color
//
//  Created by NhatMinh on 6/13/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AboutUsVC: UIViewController {
    let minhView = UIView()
    let locView = UIView()
    let tungView = UIView()
    var bannerView: GADBannerView!
    let appIconView = UIImageView()
    let appNameLabel = UILabel()
    let infoView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let navAndStatusHeight: CGFloat = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#F38181")
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor(hexString: "#F38181"),
             NSFontAttributeName: UIFont(name: "American Typewriter", size: 20)!]
        
        createImageView(appIconName: "icon")
        createNameAndEmail()
        createBackButton()
        
        //Add Advertisement
        bannerView = GADBannerView(frame: CGRect(x: screenWidth/8, y: self.view.bounds.size.height*7/8 + 10 , width: screenWidth*3/4, height: screenHeight/8 - 20))
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-1059572031766108/6780869278"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    //MARK: Back Button
    func createBackButton(){
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(popView(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    func popView(sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }

    
    func createImageView(appIconName: String){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        let navAndStatusHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.size.height)!
        
        
        appIconView.frame = CGRect(x: screenWidth/3, y: navAndStatusHeight+screenWidth/6, width:screenWidth/3, height: screenWidth/3)
        appIconView.layer.borderWidth = 1
        appIconView.layer.cornerRadius = 8
        appIconView.layer.borderColor = UIColor.black.cgColor
        appIconView.layer.masksToBounds = true
        appIconView.image = UIImage(named: appIconName)
        self.view.addSubview(appIconView)
        print(appIconView.frame.maxY)
        
        appNameLabel.frame = CGRect(x: appIconView.frame.minX, y: appIconView.frame.maxY, width: appIconView.frame.size.width, height: appIconView.frame.size.height/4)
        appNameLabel.text = "MyPalettes v.1.0.0"
        appNameLabel.textAlignment = .center
        appNameLabel.adjustsFontSizeToFitWidth = true
        appNameLabel.textColor = UIColor(hexString: "#F38181")
        appNameLabel.font = UIFont(name: "American Typewriter", size: 20)
        self.view.addSubview(appNameLabel)
        print(appNameLabel.frame.minY)
    }

    
    func createNameAndEmail(){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height

        let infoLabel = UILabel()

        infoLabel.frame = CGRect(x: 0, y: appNameLabel.frame.maxY, width: screenWidth, height: screenHeight-appNameLabel.frame.maxY)
        infoLabel.text = "\nDev. Team:\n\nHoang Nhat Minh\nnhatminh291297@gmail.com\n\nTran Thien Loc\ntomtran43@gmail.com\n\nNguyen Thanh Tung\nttungb2410@gmail.com"
        infoLabel.numberOfLines = 11
        infoLabel.textColor = UIColor(hexString: "#F38181")
        infoLabel.font = UIFont(name: "American Typewriter", size: 20)
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textAlignment = .center
        infoLabel.sizeToFit()
        infoLabel.center.x = self.view.center.x
        self.view.addSubview(infoLabel)
    }
    
}
