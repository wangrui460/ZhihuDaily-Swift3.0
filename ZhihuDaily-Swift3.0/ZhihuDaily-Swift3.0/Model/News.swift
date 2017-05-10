//
//  News.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/10.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit
//import SwiftyJSON

struct News
{
    var date:String
    var stories:[Story]
    var top_stories:[Story]?    // 可能没有 top_stories
}

extension News
{
    static func parseJson(json:[String : AnyObject]) -> News
    {
        guard let date = json["date"] as? String else {
            fatalError("error parse date")
        }

        var stories:[Story]?
        if let storiesDicts = json["stories"] as? [[String:AnyObject]]
        {
            
            stories = storiesDicts.map({ (tempJson) -> Story in
                return Story.parseJson(json: tempJson)
            })
        }
        
        var top_stories:[Story]?
        if let top_storiesDicts = json["top_stories"] as? [[String:AnyObject]]
        {
            top_stories = top_storiesDicts.map({ (tempJson) -> Story in
                return Story.parseJson(json: tempJson)
            })
        }
        
        return News(date: date, stories: stories!, top_stories: top_stories)
    }
}
