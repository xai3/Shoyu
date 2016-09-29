//
//  ReuseIdentifier.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

protocol ReuseIdentifierType {
    var identifier: String { get }
}

extension ReuseIdentifierType {
    var identifier: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last ?? ""
    }
}

extension UITableViewCell: ReuseIdentifierType { }
