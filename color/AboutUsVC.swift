//
//  AboutUsVC.swift
//  color
//
//  Created by NhatMinh on 6/13/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {
    let minhView = UIView()
    let locView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let navAndStatusHeight: CGFloat = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height
        minhView.frame = CGRect(x: 0, y: navAndStatusHeight, width: screenWidth, height: screenHeight/3)
        minhView.backgroundColor = UIColor.blue
        self.view.addSubview(minhView)
        createAuthorsInfo(authorView: minhView, authorImageName: "hihi")
        
        locView.frame = CGRect(x: 0, y: minhView.frame.maxY, width: screenWidth, height: screenHeight/3)
        locView.backgroundColor = UIColor.cyan
        self.view.addSubview(locView)
        createAuthorsInfo(authorView: locView, authorImageName: "hehe")
    }
    
    func createAuthorsInfo(authorView: UIView, authorImageName: String) {
        let authorImageView = UIImageView()
        authorImageView.frame = CGRect(x: authorView.frame.size.width/6, y: authorView.frame.size.height/3, width: authorView.frame.size.height/3, height: authorView.frame.size.height/3)
        authorImageView.image = UIImage(named: authorImageName)
        authorImageView.backgroundColor = UIColor.red
        authorView.addSubview(authorImageView)
        
    }

}
