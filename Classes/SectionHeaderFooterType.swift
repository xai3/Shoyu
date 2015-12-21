//
//  SectionHeaderFooterType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol SectionHeaderFooterType {
    var reuseIdentifier: String? { get }
    var height: CGFloat? { get set }
    var title: String? { get set }
}

protocol SectionHeaderFooterDelegateType {
    func configureView(view: UIView, section: Int)
    func heightFor(section: Int) -> CGFloat?
    func titleFor(section: Int) -> String?
    func viewFor(section: Int) -> UIView?
}
