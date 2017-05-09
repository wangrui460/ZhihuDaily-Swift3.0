//
//  UIView+Event.swift
//  ZhihuDaily-Swift3.0
//
//  Created by wangrui on 2017/5/9.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit

fileprivate let kTapGentureKey       = UnsafeRawPointer(bitPattern: "kTapGentureKey".hashValue)
fileprivate let kTapGentureActionKey = UnsafeRawPointer(bitPattern: "kTapGentureActionKey".hashValue)

// MARK: - 轻点事件
extension UIView
{
    func setTapActionWithBlock(tapBlock:(()->()))
    {
        let tapGesture = objc_getAssociatedObject(self, kTapGentureKey)
        if (tapGesture == nil)
        {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickEvent))
            self.addGestureRecognizer(tapGesture)
            objc_setAssociatedObject(self, kTapGentureKey, tapGesture, .OBJC_ASSOCIATION_RETAIN)
        }
        objc_setAssociatedObject(self, kTapGentureActionKey, (tapBlock as AnyObject) , .OBJC_ASSOCIATION_COPY)
    }
    
    func onClickEvent(tapGesture:UITapGestureRecognizer)
    {
        if (tapGesture.state == UIGestureRecognizerState.recognized)
        {
            if let tapBlock = objc_getAssociatedObject(self, kTapGentureActionKey) as? (()->())
            {
                tapBlock()
            }
        }
    }
}
