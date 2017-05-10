//
//  Story.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/10.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit

struct Story
{
    var id:Int
    var title:String
    var image:String
    var imageURL:URL {
        return URL(string: image)!
    }
    var storyURL:URL {
        return URL(string: "http://news-at.zhihu.com/api/4/news/\(id)")!
    }
}

extension Story
{
    static func parseJson(json:[String:AnyObject]) -> Story
    {
        var isTopStory:Bool {
            return json.keys.contains("image")
        }
        
        guard let id = json["id"] as? Int else {
            fatalError("error parse id")
        }
        
        guard let title = json["title"] as? String else {
            fatalError("error parse title")
        }
        
        guard let image = (isTopStory ? (json["image"] as? String) : (json["images"] as! [String])[0]) else {
            fatalError("error parse images")
        }
        
        return Story(id: id, title: title, image: image)
    }
}
