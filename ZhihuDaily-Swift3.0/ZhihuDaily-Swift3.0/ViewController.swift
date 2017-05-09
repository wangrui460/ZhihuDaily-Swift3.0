//
//  ViewController.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/5.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController
{
    let requestLatestNews = "requestLatestNews"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "知乎日报"
        WRApiContainer.requestLatestNews(reqName: requestLatestNews, delegate: self)
    }
}


extension ViewController: WRNetWrapperDelegate
{
    func netWortDidSuccess(result:AnyObject,requestName:String,parameters:NSDictionary?)
    {
        if (requestName == requestLatestNews)
        {
            let json = result as! JSON
            print("--------------------")
        }
    }
    
    func netWortDidFailed (result:AnyObject,requestName:String,parameters:NSDictionary?)
    {
        print(result.error ?? "")
    }
}





