//
//  DrawerController.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/11.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit
import SwiftyJSON

class DrawerController: MMDrawerController
{
    let requestAppVersion = "requestAppVersion"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let leftController = LeftController()
        let mainController = MainController()
        
        let leftNavController = BaseNavigationController(rootViewController: leftController)
        let mainNavController = BaseNavigationController(rootViewController: mainController)

        leftDrawerViewController = leftNavController
        centerViewController = mainNavController
        
        showsShadow = true
        restorationIdentifier = "WRDrawer"
        maximumLeftDrawerWidth = 200.0
        openDrawerGestureModeMask = .all
        closeDrawerGestureModeMask = .all
    }
    
    func checkAppVersion()
    {
        WRApiContainer.requestAppVersion(reqName: requestAppVersion, delegate: self)
    }
}


extension DrawerController: WRNetWrapperDelegate
{
    func netWortDidSuccess(result:AnyObject,requestName:String,parameters:NSDictionary?)
    {
        if (requestName == requestAppVersion)
        {
            let json = JSON(result)
            let status = json["status"].int
            if status == 1
            {
                let msg    = json["msg"].string
                let alertVC = UIAlertController(title: "版本更新提示", message: msg, preferredStyle: .alert)
                let sureAction = UIAlertAction(title: "前往", style: .destructive, handler:
                    { (success) in
                        // 因为不知道知乎日报的appid，所以这里就调到AppStore的首页
                        let url = URL(string: "itms-apps://itunes.apple.com/")
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                })
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertVC.addAction(cancelAction)
                alertVC.addAction(sureAction)
                
                //                navVC.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func netWortDidFailed (result:AnyObject,error:Error?, requestName:String,parameters:NSDictionary?)
    {
        print(error ?? "")
    }
}

