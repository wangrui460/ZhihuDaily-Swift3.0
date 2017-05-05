//
//  AppDelegate.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/5.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let navVC:UINavigationController = UINavigationController.init(rootViewController: ViewController())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }

    

}

