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
        
        createImageView(appIconName: "appIcon")
        createInfoView()
        
        //Add Advertisement
        bannerView = GADBannerView(frame: CGRect(x: screenWidth/8, y: self.view.bounds.size.height*7/8 + 10 , width: screenWidth*3/4, height: screenHeight/8 - 20))
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-1059572031766108/6780869278"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        print(infoView.frame.maxY)
        print(bannerView.frame.minY)
    }
    
    
    func createImageView(appIconName: String){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        let navAndStatusHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.size.height)!
        
        appIconView.frame = CGRect(x: screenWidth/3, y: navAndStatusHeight+screenWidth/6, width:screenWidth/3, height: screenWidth/3)
        appIconView.layer.borderWidth = 1
        appIconView.layer.cornerRadius = screenWidth/6
        appIconView.layer.borderColor = UIColor.black.cgColor
        appIconView.image = UIImage(named: appIconName)
        self.view.addSubview(appIconView)
    }

    func createInfoView(){
        let screenWidth = self.view.bounds.size.width
        let screenHeight = self.view.bounds.size.height
        let navAndStatusHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.size.height)!
        infoView.frame = CGRect(x: 0, y: appIconView.frame.maxY + screenWidth/12, width: screenWidth, height: screenHeight-appIconView.frame.maxY)
        
        createNameAndEmail(frame: CGRect(x: 0, y: 0,
                                         width: infoView.frame.size.width, height: screenWidth/6),
                           name: "Hoang Nhat Minh",
                           email: "nhatminh291297@gmail.com")
        createNameAndEmail(frame: CGRect(x: 0, y: screenWidth/6 + 20,
                                         width: infoView.frame.size.width, height: screenWidth/6),
                           name: "Tran Thien Loc",
                           email: "tomtran43@gmail.com")
        createNameAndEmail(frame: CGRect(x: 0, y: screenWidth*2/6 + 40 ,
                                         width: infoView.frame.size.width, height: screenWidth/6),
                           name: "Nguyen Thanh Tung",
                           email: "ttungb2410@gmail.com")
        self.view.addSubview(infoView)
    }
    
    func createNameAndEmail(frame: CGRect, name: String, email: String) {
        let infoLabel = UILabel()
        infoLabel.frame = frame
        infoLabel.text = "\(name)\n\(email)"
        infoLabel.numberOfLines = 2
        infoLabel.textColor = UIColor(hexString: "#F38181")
        infoLabel.font = UIFont(name: "American Typewriter", size: 20)
        infoLabel.textAlignment = .center
        infoLabel.adjustsFontSizeToFitWidth = true
        infoView.addSubview(infoLabel)
    }
    
    
    
}
