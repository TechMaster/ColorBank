//
//  AppDelegate.swift
//  color
//
//  Created by Loc Tran on 4/27/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: Prepare plist file to read and write
    var plistPathInDocument:String = String()
    func preparePlistForUse(){
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        
        plistPathInDocument = rootPath+"/colorData.plist"
        print(plistPathInDocument)
        if !FileManager.default.fileExists(atPath: plistPathInDocument){
            let plistPathInBundle = Bundle.main.path(forResource: "colorData", ofType: "plist") as String!
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: plistPathInDocument)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    var colorData270PlistPath:String = String()
    
    func prepareSubPlistForUse(){
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        
        colorData270PlistPath = rootPath+"/colorData270.plist"
        if !FileManager.default.fileExists(atPath: colorData270PlistPath){
            let plistPathInBundle = Bundle.main.path(forResource: "colorData270", ofType: "plist") as String!
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: colorData270PlistPath)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    var plistPathYourPalettes:String = String()
    func preparePlistYourPalettesForUse(){
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        
        plistPathYourPalettes = rootPath+"/yourPalettes.plist"
        if !FileManager.default.fileExists(atPath: plistPathYourPalettes){
            let plistPathInBundle = Bundle.main.path(forResource: "yourPalettes", ofType: "plist") as String!
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: plistPathYourPalettes)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navi = UINavigationController()
        let mainView = ViewController()
        navi.viewControllers = [mainView]
        self.window!.rootViewController = navi
        self.window?.makeKeyAndVisible()
        
        //Prepare pList file for write and read
        self.preparePlistForUse()
        self.preparePlistYourPalettesForUse()
        self.prepareSubPlistForUse()
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-1059572031766108~6237642472
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1059572031766108~6237642472")
        //Hide backIndicatorImage for NavigationBar in all ViewController
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-10, 0), for: UIBarMetrics.default)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.preparePlistForUse()
        self.preparePlistYourPalettesForUse()
        self.prepareSubPlistForUse()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "color")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

