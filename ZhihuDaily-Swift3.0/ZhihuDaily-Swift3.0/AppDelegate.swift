//
//  AppDelegate.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/5.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let requestSplashImage = "requestSplashImage"
    var bgImageView:UIImageView? = UIImageView(frame: UIScreen.main.bounds)
    var advImageView:UIImageView?
    let jumpBtn = UIButton()
    let SPLASHIMAGE = "SPLASHIMAGE"
    let drawerController = DrawerController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        WRApiContainer.requestSplashImage(reqName: requestSplashImage, delegate: self)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
        
        addAdvertisement()
        removeAdvertisement()
        return true
    }
}


//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - 启动闪屏广告相关
extension AppDelegate
{
    /// 添加广告
    fileprivate func addAdvertisement()
    {
        bgImageView?.image = UIImage(named: "backImage")
        window!.addSubview(bgImageView!)
        if (IS_SCREEN_4_INCH) {
            advImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 100))
        } else if (IS_SCREEN_47_INCH) {
            advImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 115))
        } else {
            advImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 130))
        }
        bgImageView?.addSubview(advImageView!)
        if let data = UserDefaults.standard.object(forKey: SPLASHIMAGE) as? Data
        {
            advImageView?.image = UIImage(data: data)
        }
        
        bgImageView?.isUserInteractionEnabled = true
        advImageView?.isUserInteractionEnabled = true
        jumpBtn.setTitle("跳过", for: .normal)
        jumpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        jumpBtn.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        jumpBtn.setTitleColor(UIColor.white, for: .normal)
        advImageView?.addSubview(jumpBtn)
        jumpBtn.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(25)
            make.top.equalTo(self.advImageView!).offset(30)
            make.right.equalTo(self.advImageView!).offset(-30)
        }
        jumpBtn.layer.cornerRadius = 6
        jumpBtn.layer.masksToBounds = true
        jumpBtn.setTapActionWithBlock { [weak self] in
            if let weakSelf = self
            {
                weakSelf.bgImageView?.removeFromSuperview()
                weakSelf.bgImageView = nil
                weakSelf.drawerController.checkAppVersion()
            }
        }
        jumpBtn.isHidden = true
    }
    
    /// 移除广告
    fileprivate func removeAdvertisement()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute:
            {
                UIView.animate(withDuration: 1.0, animations:
                    {
                        self.advImageView?.alpha = 0
                        self.bgImageView?.alpha = 0
                },completion: { (finish) in
                    self.bgImageView?.removeFromSuperview()
                    if self.bgImageView != nil {
                        self.drawerController.checkAppVersion()
                    }
                    self.bgImageView = nil
                })
        })
    }
}


//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - WRNetWrapperDelegate
extension AppDelegate: WRNetWrapperDelegate
{
    func netWortDidSuccess(result: AnyObject, requestName: String, parameters: NSDictionary?)
    {
        if (requestName == requestSplashImage)
        {
            let json = JSON(result)
//            let dict = json.dictionaryValue
//            let creatives = dict["creatives"]
//            let url = creatives?[0]["url"].string
            
            let splashUrl = json.dictionaryValue["creatives"]?[0]["url"].string
            
            // 对喵神的 Kingfisher 修改了一下，解决了当placeholder为nil的时候，如果原图片框中已有图片，则会闪一下的问题
            // https://github.com/wangrui460/Kingfisher
            advImageView?.kf.setImage(with: URL(string: splashUrl!), completionHandler:
            { [weak self] (image, error, cachtType, url) in
                if let weakSelf = self
                {
                    weakSelf.jumpBtn.isHidden = false
                    let data = UIImagePNGRepresentation(image!)
                    UserDefaults.standard.set(data, forKey: weakSelf.SPLASHIMAGE)
                }
            })
            return
        }
    }
    
    func netWortDidFailed(result: AnyObject, error:Error?, requestName: String, parameters: NSDictionary?)
    {
        print("\(requestName)---\(error)---")
    }
}







