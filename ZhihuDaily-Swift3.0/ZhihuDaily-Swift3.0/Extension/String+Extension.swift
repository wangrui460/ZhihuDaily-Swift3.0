//
//  String+Extension.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/10.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import Foundation

extension String
{
    func currentWeekDay() -> String
    {
        let weekDays = [ "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
//        let calendarUnit = UnitWeekday
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.date(from: self)
        let components:DateComponents = calendar.dateComponents(in: timeZone!, from: date!)
        return weekDays[components.weekday!-1]
    }
}
