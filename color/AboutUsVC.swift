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
        
        minhView.frame = CGRect(x: 0, y: navAndStatusHeight, width: screenWidth, height: screenHeight/4)
        self.view.addSubview(minhView)
        createAuthorsInfo(authorView: minhView, authorImageName: "Hoàng Nhật Minh", emailAddress: "nhatminh291297@gmail.com")
        
        locView.frame = CGRect(x: 0, y: minhView.frame.maxY, width: screenWidth, height: screenHeight/4)
        self.view.addSubview(locView)
        createAuthorsInfo(authorView: locView, authorImageName: "Trần Thiện Lộc", emailAddress: "tomtran43@gmail.com")
        
        tungView.frame = CGRect(x: 0, y: locView.frame.maxY, width: screenWidth, height: screenHeight/4)
        self.view.addSubview(tungView)
        createAuthorsInfo(authorView: tungView, authorImageName: "Nguyễn Thanh Tùng", emailAddress: "ttungb2410@gmail.com")
        
        //Add Advertisement
        bannerView = GADBannerView(frame: CGRect(x: 0, y: tungView.frame.maxY, width: screenWidth, height: screenHeight-tungView.frame.maxY))
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-1059572031766108/6780869278"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,                       // All simulators
            "2077ef9a63d2b398840261c8221a0c9b" ]
        bannerView.load(request)
    }
    
    func createAuthorsInfo(authorView: UIView, authorImageName: String, emailAddress: String) {
        let authorImageView = UIImageView()
        authorImageView.frame = CGRect(x: 10, y: 10, width: authorView.frame.size.height - 20, height: authorView.frame.size.height - 20)
        authorImageView.layer.borderWidth = 1
        authorImageView.layer.borderColor = UIColor.black.cgColor
        authorImageView.image = UIImage(named: authorImageName)
        authorView.addSubview(authorImageView)
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: authorImageView.frame.maxX + 10, y: 10, width: authorView.frame.size.width - authorImageView.frame.size.width - 30, height: authorImageView.frame.size.height/3)
        nameLabel.text = "Name: \(authorImageName)"
        nameLabel.textColor = UIColor(hexString: "#F38181")
        nameLabel.font = UIFont(name: "American Typewriter", size: 20)
        nameLabel.textAlignment = .left
        nameLabel.adjustsFontSizeToFitWidth = true
        authorView.addSubview(nameLabel)
        
        let emailLabel = UILabel()
        emailLabel.frame = CGRect(x: authorImageView.frame.maxX + 10, y: nameLabel.frame.maxY, width: authorView.frame.size.width - authorImageView.frame.size.width - 30, height: authorImageView.frame.size.height/3)
        emailLabel.text = "Email: \(emailAddress)"
        emailLabel.textColor = UIColor(hexString: "#F38181")
        emailLabel.font = UIFont(name: "American Typewriter", size: 20)
        emailLabel.textAlignment = .center
        emailLabel.adjustsFontSizeToFitWidth = true
        authorView.addSubview(emailLabel)
    }
    
}
