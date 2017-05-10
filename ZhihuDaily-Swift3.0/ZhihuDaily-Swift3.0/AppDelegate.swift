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
    let requestAppVersion = "requestAppVersion"
    var bgImageView:UIImageView? = UIImageView(frame: UIScreen.main.bounds)
    var advImageView:UIImageView?
    let jumpBtn = UIButton()
    let SPLASHIMAGE = "SPLASHIMAGE"
    let navVC:UINavigationController = UINavigationController.init(rootViewController: ViewController())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        WRApiContainer.requestSplashImage(reqName: requestSplashImage, delegate: self)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        addAdvertisement()
        removeAdvertisement()
        return true
    }
    
    
    /// 添加广告
    private func addAdvertisement()
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
                WRApiContainer.requestAppVersion(reqName: weakSelf.requestAppVersion, delegate: weakSelf)
            }
        }
        jumpBtn.isHidden = true
    }

    /// 移除广告
    private func removeAdvertisement()
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
                    WRApiContainer.requestAppVersion(reqName: self.requestAppVersion, delegate: self)
                }
                self.bgImageView = nil
            })
        })
    }
}



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
                navVC.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func netWortDidFailed(result: AnyObject, error:Error?, requestName: String, parameters: NSDictionary?)
    {
        print("\(requestName)---\(error)---")
    }
}







