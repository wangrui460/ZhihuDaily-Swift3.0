//
//  ViewController.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/5.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit
import SwiftyJSON

private let NAVBAR_COLORCHANGE_POINT:CGFloat = -80
private let IMAGE_HEIGHT:CGFloat = 210
private let SCROLL_DOWN_LIMIT:CGFloat = 100
private let LIMIT_OFFSET_Y:CGFloat = -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
private let MainNavBarColor = UIColor.init(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)

class MainController: BaseViewController
{
    let requestLatestNews = "requestLatestNews"
    var latestNews:News?
    
    lazy var tableView:UITableView = {
        let table:UITableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: Int(self.view.bounds.height)), style: .plain)
        table.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-CGFloat(kNavBarBottom), 0, 0, 0);
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    lazy var cycleScrollView:WRCycleScrollView = {
        let frame = CGRect(x: 0, y: -IMAGE_HEIGHT, width: CGFloat(kScreenWidth), height: IMAGE_HEIGHT)
        let cycleView = WRCycleScrollView(frame: frame, type: .LOCAL, imgs: nil, descs: nil)
        return cycleView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        WRApiContainer.requestLatestNews(reqName: requestLatestNews, delegate: self)
        self.title = "知乎日报"
        tableView.addSubview(cycleScrollView)
        view.addSubview(tableView)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.wr_setBackgroundColor(color: .clear)
    }
}


extension MainController: WRNetWrapperDelegate
{
    func netWortDidSuccess(result:AnyObject,requestName:String,parameters:NSDictionary?)
    {
        if (requestName == requestLatestNews)
        {
            let news = News.parseJson(json: result as! [String:AnyObject])
            print(news.format_date)
            cycleScrollView.serverImgArray = news.topStoryImgs
            cycleScrollView.descTextArray = news.topStoryTitles
            cycleScrollView.imgsType = .SERVER
            cycleScrollView.autoScrollInterval = 3
            cycleScrollView.reloadData()
        }
    }
    
    func netWortDidFailed (result:AnyObject,error:Error?, requestName:String,parameters:NSDictionary?)
    {
        print(error ?? "")
    }
}

extension MainController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        let str = String(format: "知乎日报 %zd", indexPath.row)
        cell.textLabel?.text = str
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc:UIViewController = UIViewController()
        vc.view.backgroundColor = UIColor.red
        let str = String(format: "知乎日报 %zd", indexPath.row)
        vc.title = str
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - viewWillAppear .. ScrollViewDidScroll
extension MainController
{
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.delegate = self
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.wr_setBackgroundColor(color: .clear)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        tableView.delegate = nil
        navigationController?.navigationBar.wr_clear()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        
        if (offsetY > NAVBAR_COLORCHANGE_POINT)
        {
            let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / CGFloat(kNavBarBottom)
            navigationController?.navigationBar.wr_setBackgroundColor(color: MainNavBarColor.withAlphaComponent(alpha))
        }
        else
        {
            navigationController?.navigationBar.wr_setBackgroundColor(color: .clear)
        }
        
        // 限制下拉距离
        if (offsetY < LIMIT_OFFSET_Y) {
            scrollView.contentOffset = CGPoint.init(x: 0, y: LIMIT_OFFSET_Y)
        }
        
        // 改变图片框的大小 (上滑的时候不改变)
        // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
        let newOffsetY = scrollView.contentOffset.y
        if (newOffsetY < -IMAGE_HEIGHT)
        {
            cycleScrollView.frame = CGRect(x: 0, y: newOffsetY, width: CGFloat(kScreenWidth), height: -newOffsetY)
        }
    }
    
    // private
    fileprivate func imageScaledToSize(image:UIImage, newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: newSize.width * 2.0, height: newSize.height * 2.0))
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width * 2.0, height: newSize.height * 2.0))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return newImage
    }
}

