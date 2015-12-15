//
//  UITableView+Source.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit
import ObjectiveC

struct UITableViewAssociatedObjectHandle {
    static var Source: UInt8 = 0
}

public extension UITableView {
    public var source: Source? {
        set {
            objc_setAssociatedObject(self, &UITableViewAssociatedObjectHandle.Source, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            dataSource = newValue
            delegate = newValue
        }
        get {
            return objc_getAssociatedObject(self, &UITableViewAssociatedObjectHandle.Source) as? Source
        }
    }
}
