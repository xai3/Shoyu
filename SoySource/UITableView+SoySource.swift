//
//  UITableView+SoySource.swift
//  SoySource
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit
import ObjectiveC

struct UITableViewAssociatedObjectHandle {
    static var SoySource: UInt8 = 0
}

extension UITableView {
    var soySource: SoySource? {
        set {
            objc_setAssociatedObject(self, &UITableViewAssociatedObjectHandle.SoySource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            dataSource = newValue
            delegate = newValue
        }
        get {
            return objc_getAssociatedObject(self, &UITableViewAssociatedObjectHandle.SoySource) as? SoySource
        }
    }
}

extension UITableView {
    func dequeueReusableCellWithIdentifier<T>(identifier: ReuseIdentifier<T>, forIndexPath indexPath: NSIndexPath) -> T? {
        return dequeueReusableCellWithIdentifier(identifier.value, forIndexPath: indexPath) as? T
    }
}

